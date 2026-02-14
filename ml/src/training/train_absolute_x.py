#!/usr/bin/env python3
"""
Train handedness-invariant model using ABSOLUTE X COORDINATES.
Takes absolute value of X coordinates after centering, making left and
right hands identical. Simple but loses some directional information.
"""

import torch
import torch.nn as nn
import torch.optim as optim
from torch.utils.data import Dataset, DataLoader
import numpy as np
import os
from collections import Counter
from sklearn.model_selection import train_test_split
from sklearn.metrics import confusion_matrix, classification_report
import matplotlib.pyplot as plt
import seaborn as sns
import json
from tqdm import tqdm

# ============================================================================
# Config
# ============================================================================
class Config:
    LANDMARKS_DIR = './output/fullDataset_augmented'  # Original augmented dataset
    OUTPUT_DIR = "./output/absolute_x"  # Absolute X coordinates approach

    NUM_CLASSES = 28  # 28 Arabic letters
    NUM_FEATURES = 63  # 21 landmarks × 3 coordinates

    HIDDEN_SIZE = 256
    DROPOUT = 0.1

    BATCH_SIZE = 8
    NUM_EPOCHS = 150
    LEARNING_RATE = 0.0001

    PATIENCE = 20  # Early stopping
    VAL_SPLIT = 0.1
    TEST_SPLIT = 0.2
    SEED = 42

# ============================================================================
# Dataset
# ============================================================================
class HandOnlyDataset(Dataset):
    def __init__(self, data_paths, labels):
        self.data_paths = data_paths
        self.labels = labels

    def __len__(self):
        return len(self.data_paths)

    def __getitem__(self, idx):
        data = np.load(self.data_paths[idx])
        hand = data['hand']  # (21, 3)

        # 1. Translation invariance: center on wrist
        wrist = hand[0]
        hand_centered = hand - wrist

        # 2. Handedness normalization: use absolute X coordinates
        # This makes left and right hands identical
        hand_centered[:, 0] = np.abs(hand_centered[:, 0])

        # 3. Scale invariance: normalize by max distance
        distances = np.linalg.norm(hand_centered, axis=1)
        max_distance = np.max(distances)

        if max_distance > 1e-6:
            hand_normalized = hand_centered / max_distance
        else:
            hand_normalized = hand_centered

        features = torch.FloatTensor(hand_normalized.flatten())
        label = torch.LongTensor([self.labels[idx]])[0]

        return features, label

# ============================================================================
# Model (same architecture as before)
# ============================================================================
class SimpleModel(nn.Module):
    def __init__(self, input_size=63, hidden_size=256, num_classes=28, dropout=0.1):
        super().__init__()

        self.network = nn.Sequential(
            nn.Linear(input_size, 512),
            nn.ReLU(),
            nn.BatchNorm1d(512),
            nn.Dropout(dropout),

            nn.Linear(512, 256),
            nn.ReLU(),
            nn.BatchNorm1d(256),
            nn.Dropout(dropout),

            nn.Linear(256, 128),
            nn.ReLU(),
            nn.BatchNorm1d(128),
            nn.Dropout(dropout),

            nn.Linear(128, num_classes)
        )

    def forward(self, x):
        return self.network(x)

# ============================================================================
# Data Collection
# ============================================================================
def collect_data_stratified(landmarks_dir=Config.LANDMARKS_DIR,
                           test_split=Config.TEST_SPLIT,
                           val_split=Config.VAL_SPLIT,
                           num_classes=Config.NUM_CLASSES,
                           seed=Config.SEED,
                           truncate=True):
    """Collect data with stratified split, optionally truncating to balance classes"""

    print("="*80)
    print("COLLECTING DATA WITH ABSOLUTE X NORMALIZATION")
    print("="*80)

    # Collect per-class first
    import random
    random.seed(seed)

    class_paths = {i: [] for i in range(num_classes)}

    for split in ['train', 'test']:
        for class_idx in range(1, num_classes + 1):
            class_path = os.path.join(landmarks_dir, split, str(class_idx))

            if not os.path.exists(class_path):
                continue

            files = [f for f in os.listdir(class_path) if f.endswith('.npz')]

            for file in files:
                file_path = os.path.join(class_path, file)
                class_paths[class_idx - 1].append(file_path)

    # Print original counts
    print("\nSamples per class (before truncation):")
    for class_idx in range(num_classes):
        print(f"  Class {class_idx:2d}: {len(class_paths[class_idx]):5d} samples")

    # Truncate to minimum class size for balance
    if truncate:
        min_count = min(len(paths) for paths in class_paths.values() if paths)
        print(f"\nTruncating all classes to {min_count} samples (min class size)")

        for class_idx in range(num_classes):
            if len(class_paths[class_idx]) > min_count:
                random.shuffle(class_paths[class_idx])
                class_paths[class_idx] = class_paths[class_idx][:min_count]

    # Flatten
    all_paths = []
    all_labels = []
    for class_idx in range(num_classes):
        for path in class_paths[class_idx]:
            all_paths.append(path)
            all_labels.append(class_idx)

    print(f"\nTotal samples: {len(all_paths):,}")

    label_counts = Counter(all_labels)
    print("\nSamples per class (after truncation):")
    for class_idx in range(num_classes):
        count = label_counts[class_idx]
        print(f"  Class {class_idx:2d}: {count:5d} samples")

    # Stratified split
    train_val_paths, test_paths, train_val_labels, test_labels = train_test_split(
        all_paths, all_labels,
        test_size=test_split,
        stratify=all_labels,
        random_state=seed
    )

    train_paths, val_paths, train_labels, val_labels = train_test_split(
        train_val_paths, train_val_labels,
        test_size=val_split,
        stratify=train_val_labels,
        random_state=seed
    )

    print(f"\nStratified split:")
    print(f"  Train: {len(train_paths):,} samples")
    print(f"  Val:   {len(val_paths):,} samples")
    print(f"  Test:  {len(test_paths):,} samples")

    return train_paths, train_labels, val_paths, val_labels, test_paths, test_labels

# ============================================================================
# Training
# ============================================================================
def train_model():
    """Train the handedness-invariant model"""

    # Set seeds
    torch.manual_seed(Config.SEED)
    np.random.seed(Config.SEED)

    # Create output directory
    os.makedirs(Config.OUTPUT_DIR, exist_ok=True)

    # Collect data
    train_paths, train_labels, val_paths, val_labels, test_paths, test_labels = collect_data_stratified()

    # Create datasets
    train_dataset = HandOnlyDataset(train_paths, train_labels)
    val_dataset = HandOnlyDataset(val_paths, val_labels)
    test_dataset = HandOnlyDataset(test_paths, test_labels)

    # Create dataloaders (drop_last=True to avoid BatchNorm error with batch_size=1)
    train_loader = DataLoader(train_dataset, batch_size=Config.BATCH_SIZE, shuffle=True, drop_last=True)
    val_loader = DataLoader(val_dataset, batch_size=Config.BATCH_SIZE, shuffle=False)
    test_loader = DataLoader(test_dataset, batch_size=Config.BATCH_SIZE, shuffle=False)

    # Model, loss, optimizer
    device = torch.device('cuda' if torch.cuda.is_available() else 'cpu')
    print(f"\nUsing device: {device}")

    model = SimpleModel(
        input_size=Config.NUM_FEATURES,
        hidden_size=Config.HIDDEN_SIZE,
        num_classes=Config.NUM_CLASSES,
        dropout=Config.DROPOUT
    ).to(device)

    print(f"\nModel parameters: {sum(p.numel() for p in model.parameters()):,}")

    criterion = nn.CrossEntropyLoss()
    optimizer = optim.Adam(model.parameters(), lr=Config.LEARNING_RATE)
    scheduler = optim.lr_scheduler.ReduceLROnPlateau(
        optimizer, mode='max', factor=0.5, patience=10
    )

    # Training loop
    print("\n" + "="*80)
    print("TRAINING HANDEDNESS-INVARIANT MODEL (ABSOLUTE X COORDINATES)")
    print("="*80)

    history = {
        'train_loss': [],
        'train_acc': [],
        'val_loss': [],
        'val_acc': []
    }

    best_val_acc = 0
    patience_counter = 0

    for epoch in range(Config.NUM_EPOCHS):
        # Train
        model.train()
        train_loss = 0
        train_correct = 0
        train_total = 0

        pbar = tqdm(train_loader, desc=f"Epoch {epoch+1}/{Config.NUM_EPOCHS}")
        for features, labels in pbar:
            features, labels = features.to(device), labels.to(device)

            optimizer.zero_grad()
            outputs = model(features)
            loss = criterion(outputs, labels)
            loss.backward()
            optimizer.step()

            train_loss += loss.item()
            _, predicted = outputs.max(1)
            train_total += labels.size(0)
            train_correct += predicted.eq(labels).sum().item()

            pbar.set_postfix({
                'loss': f'{loss.item():.4f}',
                'acc': f'{100.*train_correct/train_total:.2f}%'
            })

        # Validate
        model.eval()
        val_loss = 0
        val_correct = 0
        val_total = 0

        with torch.no_grad():
            for features, labels in val_loader:
                features, labels = features.to(device), labels.to(device)
                outputs = model(features)
                loss = criterion(outputs, labels)

                val_loss += loss.item()
                _, predicted = outputs.max(1)
                val_total += labels.size(0)
                val_correct += predicted.eq(labels).sum().item()

        # Calculate metrics
        train_loss = train_loss / len(train_loader)
        train_acc = 100. * train_correct / train_total
        val_loss = val_loss / len(val_loader)
        val_acc = 100. * val_correct / val_total

        history['train_loss'].append(train_loss)
        history['train_acc'].append(train_acc)
        history['val_loss'].append(val_loss)
        history['val_acc'].append(val_acc)

        print(f"Epoch {epoch+1}: Train Loss={train_loss:.4f}, Train Acc={train_acc:.2f}%, "
              f"Val Loss={val_loss:.4f}, Val Acc={val_acc:.2f}%")

        # Learning rate scheduling
        scheduler.step(val_acc)

        # Early stopping
        if val_acc > best_val_acc:
            best_val_acc = val_acc
            patience_counter = 0
            # Save best model
            torch.save(model.state_dict(), os.path.join(Config.OUTPUT_DIR, 'best_model.pth'))
            print(f"  → New best validation accuracy: {best_val_acc:.2f}%")
        else:
            patience_counter += 1
            if patience_counter >= Config.PATIENCE:
                print(f"\nEarly stopping after {epoch+1} epochs")
                break

    # Load best model for evaluation
    model.load_state_dict(torch.load(os.path.join(Config.OUTPUT_DIR, 'best_model.pth')))

    # Test evaluation
    print("\n" + "="*80)
    print("FINAL EVALUATION ON TEST SET")
    print("="*80)

    model.eval()
    all_preds = []
    all_labels = []

    with torch.no_grad():
        for features, labels in test_loader:
            features, labels = features.to(device), labels.to(device)
            outputs = model(features)
            _, predicted = outputs.max(1)

            all_preds.extend(predicted.cpu().numpy())
            all_labels.extend(labels.cpu().numpy())

    test_acc = 100. * sum(np.array(all_preds) == np.array(all_labels)) / len(all_labels)
    print(f"\nTest Accuracy: {test_acc:.2f}%")

    # Save results
    with open(os.path.join(Config.OUTPUT_DIR, 'history.json'), 'w') as f:
        json.dump(history, f, indent=2)

    # Confusion matrix
    cm = confusion_matrix(all_labels, all_preds)
    plt.figure(figsize=(12, 10))
    sns.heatmap(cm, annot=True, fmt='d', cmap='Blues')
    plt.title('Confusion Matrix - Handedness-Invariant Model')
    plt.ylabel('True Label')
    plt.xlabel('Predicted Label')
    plt.tight_layout()
    plt.savefig(os.path.join(Config.OUTPUT_DIR, 'confusion_matrix.png'))
    print(f"Confusion matrix saved to {Config.OUTPUT_DIR}/confusion_matrix.png")

    # Per-class accuracy
    per_class_acc = {}
    for i in range(Config.NUM_CLASSES):
        mask = np.array(all_labels) == i
        if mask.sum() > 0:
            acc = 100. * (np.array(all_preds)[mask] == i).sum() / mask.sum()
            per_class_acc[i] = acc

    with open(os.path.join(Config.OUTPUT_DIR, 'per_class_accuracy.json'), 'w') as f:
        json.dump(per_class_acc, f, indent=2)

    print("\n" + "="*80)
    print("TRAINING COMPLETE")
    print("="*80)
    print(f"\nBest validation accuracy: {best_val_acc:.2f}%")
    print(f"Test accuracy: {test_acc:.2f}%")
    print(f"\nModel saved to: {Config.OUTPUT_DIR}/best_model.pth")


if __name__ == "__main__":
    train_model()
