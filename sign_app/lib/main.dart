// ignore_for_file: unused_element
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ArslApp());
}

class ArslApp extends StatefulWidget {
  const ArslApp({super.key});

  @override
  State<ArslApp> createState() => _ArslAppState();
}

enum AppLanguage { arabic, english }

class _ArslAppState extends State<ArslApp> {
  ThemeMode _themeMode = ThemeMode.light;
  double _textScaleFactor = 1.0;
  AppLanguage _language = AppLanguage.arabic;

  ThemeMode get themeMode => _themeMode;
  double get textScaleFactor => _textScaleFactor;
  AppLanguage get language => _language;

  void updateThemeMode(ThemeMode mode) {
    setState(() {
      _themeMode = mode;
    });
  }

  void updateTextScale(double value) {
    setState(() {
      _textScaleFactor = value;
    });
  }

  void updateLanguage(AppLanguage lang) {
    setState(() {
      _language = lang;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ArSL Sign Recognition',
      debugShowCheckedModeBanner: false,
      themeMode: _themeMode,

      // LIGHT THEME
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF005CA9),
          brightness: Brightness.light,
        ),
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFFF5F5F5),
      ),

      // DARK THEME
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF005CA9),
          brightness: Brightness.dark,
        ),
        brightness: Brightness.dark,
      ),

      // global textScale + RTL/LTR based on language
      builder: (context, child) {
        final mediaQuery = MediaQuery.of(context);
        return MediaQuery(
          data: mediaQuery.copyWith(
            textScaleFactor: _textScaleFactor,
          ),
          child: Directionality(
            textDirection: _language == AppLanguage.arabic
                ? TextDirection.rtl
                : TextDirection.ltr,
            child: child ?? const SizedBox.shrink(),
          ),
        );
      },

      initialRoute: '/',
      routes: {
        '/': (context) => const WelcomeScreen(),
        '/auth': (context) => const AuthChoiceScreen(),
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignupScreen(),
        '/home': (context) => const HomeScreen(),
        '/detect': (context) => const LiveDetectionScreen(),
        '/practice': (context) => const PracticeScreen(),
        '/history': (context) => const HistoryScreen(),
        '/settings': (context) => const SettingsScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == SignDetailScreen.routeName) {
          final sign = settings.arguments as SignItem;
          return MaterialPageRoute(
            builder: (_) => SignDetailScreen(sign: sign),
          );
        }
        return null;
      },
    );
  }
}

/// translation helper
String tr(BuildContext context, String ar, String en) {
  final appState = context.findAncestorStateOfType<_ArslAppState>();
  final lang = appState?.language ?? AppLanguage.arabic;
  return lang == AppLanguage.arabic ? ar : en;
}

//
// MODELS (dummy)
//

class SignItem {
  final String label; // Arabic letter or word (doesn’t change)
  final String nameAr;
  final String nameEn;
  final String categoryAr;
  final String categoryEn;
  final String descriptionAr;
  final String descriptionEn;
  final String imageAsset;

  const SignItem({
    required this.label,
    required this.nameAr,
    required this.nameEn,
    required this.categoryAr,
    required this.categoryEn,
    required this.descriptionAr,
    required this.descriptionEn,
    required this.imageAsset,
  });
}


final List<SignItem> mockSigns = [

  // ا
  SignItem(
    label: 'ا',
    nameAr: 'حرف الألف',
    nameEn: 'Letter Alef',
    categoryAr: 'حرف',
    categoryEn: 'Letter',
    descriptionAr: 'شكل مستقيم للأصابع مع رفع اليد بشكل بسيط.',
    descriptionEn: 'Straight fingers in an upright simple posture.',
    imageAsset: 'assets/signs/alef.jpg',
  ),

  // ب
  SignItem(
    label: 'ب',
    nameAr: 'حرف الباء',
    nameEn: 'Letter Baa',
    categoryAr: 'حرف',
    categoryEn: 'Letter',
    descriptionAr: 'مدّ الأصابع للأمام مع إخفاء الإبهام.',
    descriptionEn: 'Extend fingers forward while tucking the thumb in.',
    imageAsset: 'assets/signs/baa.jpg',
  ),

  // ت
  SignItem(
    label: 'ت',
    nameAr: 'حرف التاء',
    nameEn: 'Letter Taa',
    categoryAr: 'حرف',
    categoryEn: 'Letter',
    descriptionAr: 'مدّ ثلاثة أصابع مع إغلاق الخنصر والإبهام.',
    descriptionEn: 'Extend three fingers while keeping thumb and pinky closed.',
    imageAsset: 'assets/signs/taa.jpg',
  ),

  // ث
  SignItem(
    label: 'ث',
    nameAr: 'حرف الثاء',
    nameEn: 'Letter Thaa',
    categoryAr: 'حرف',
    categoryEn: 'Letter',
    descriptionAr: 'ثلاثة أصابع ممتدة مع فصل بسيط بينها.',
    descriptionEn: 'Three extended fingers with slight separation.',
    imageAsset: 'assets/signs/thaa.jpg',
  ),

  // ج
  SignItem(
    label: 'ج',
    nameAr: 'حرف الجيم',
    nameEn: 'Letter Jeem',
    categoryAr: 'حرف',
    categoryEn: 'Letter',
    descriptionAr: 'شكل منحني باليد كما لو أنك ترسم نصف دائرة.',
    descriptionEn: 'Curved hand shape as if drawing a small semicircle.',
    imageAsset: 'assets/signs/jeem.jpg',
  ),

  // ح
  SignItem(
    label: 'ح',
    nameAr: 'حرف الحاء',
    nameEn: 'Letter Haa',
    categoryAr: 'حرف',
    categoryEn: 'Letter',
    descriptionAr: 'شكل حرف C مفتوح بخفة مع استرخاء الأصابع.',
    descriptionEn: 'A gentle C-shaped hand with relaxed fingers.',
    imageAsset: 'assets/signs/haa.jpg',
  ),

  // خ
  SignItem(
    label: 'خ',
    nameAr: 'حرف الخاء',
    nameEn: 'Letter Khaa',
    categoryAr: 'حرف',
    categoryEn: 'Letter',
    descriptionAr: 'نفس شكل الحاء مع رفع اليد قليلاً.',
    descriptionEn: 'Same as Haa but with the hand raised slightly.',
    imageAsset: 'assets/signs/khaa.jpg',
  ),

  // د
  SignItem(
    label: 'د',
    nameAr: 'حرف الدال',
    nameEn: 'Letter Daal',
    categoryAr: 'حرف',
    categoryEn: 'Letter',
    descriptionAr: 'مدّ السبابة للأمام مع ميل بسيط لليد.',
    descriptionEn: 'Extend the index finger forward with a slight tilt.',
    imageAsset: 'assets/signs/daal.jpg',
  ),

  // ذ
  SignItem(
    label: 'ذ',
    nameAr: 'حرف الذال',
    nameEn: 'Letter Thaal',
    categoryAr: 'حرف',
    categoryEn: 'Letter',
    descriptionAr: 'السبابة ممتدة مع ميلها قليلاً للأعلى.',
    descriptionEn: 'Index finger extended and angled slightly upward.',
    imageAsset: 'assets/signs/thaal.jpg',
  ),

  // ر
  SignItem(
    label: 'ر',
    nameAr: 'حرف الراء',
    nameEn: 'Letter Raa',
    categoryAr: 'حرف',
    categoryEn: 'Letter',
    descriptionAr: 'مدّ السبابة للأسفل بشكل مسترخٍ.',
    descriptionEn: 'Relaxed index finger pointing downward.',
    imageAsset: 'assets/signs/raa.jpg',
  ),

  // ز
  SignItem(
    label: 'ز',
    nameAr: 'حرف الزاي',
    nameEn: 'Letter Zay',
    categoryAr: 'حرف',
    categoryEn: 'Letter',
    descriptionAr: 'السبابة ممتدة مع حركة صغيرة بالمعصم.',
    descriptionEn: 'Index finger extended with a small wrist movement.',
    imageAsset: 'assets/signs/zay.jpg',
  ),

  // س
  SignItem(
    label: 'س',
    nameAr: 'حرف السين',
    nameEn: 'Letter Seen',
    categoryAr: 'حرف',
    categoryEn: 'Letter',
    descriptionAr: 'ثلاثة أصابع مستقيمة للأمام.',
    descriptionEn: 'Three straight fingers extended forward.',
    imageAsset: 'assets/signs/seen.jpg',
  ),

  // ش
  SignItem(
    label: 'ش',
    nameAr: 'حرف الشين',
    nameEn: 'Letter Sheen',
    categoryAr: 'حرف',
    categoryEn: 'Letter',
    descriptionAr: 'ثلاثة أصابع ممتدة ومتباعدة قليلاً.',
    descriptionEn: 'Three extended fingers, slightly separated.',
    imageAsset: 'assets/signs/sheen.jpg',
  ),

  // ص
  SignItem(
    label: 'ص',
    nameAr: 'حرف الصاد',
    nameEn: 'Letter Saad',
    categoryAr: 'حرف',
    categoryEn: 'Letter',
    descriptionAr: 'اليد مستقيمة والأصابع متقاربة بقوة.',
    descriptionEn: 'Straight, firm hand with fingers together.',
    imageAsset: 'assets/signs/saad.jpg',
  ),

  // ض
  SignItem(
    label: 'ض',
    nameAr: 'حرف الضاد',
    nameEn: 'Letter Daad',
    categoryAr: 'حرف',
    categoryEn: 'Letter',
    descriptionAr: 'مثل الصاد مع ملامسة الإبهام للسبابة.',
    descriptionEn: 'Like Saad but thumb touches the index finger.',
    imageAsset: 'assets/signs/daad.jpg',
  ),

  // ط
  SignItem(
    label: 'ط',
    nameAr: 'حرف الطاء',
    nameEn: 'Letter Ttaa',
    categoryAr: 'حرف',
    categoryEn: 'Letter',
    descriptionAr: 'رفع السبابة للأعلى بثبات.',
    descriptionEn: 'Index finger extended upward firmly.',
    imageAsset: 'assets/signs/ttaa.jpg',
  ),

  // ظ
  SignItem(
    label: 'ظ',
    nameAr: 'حرف الظاء',
    nameEn: 'Letter Thaa (emphatic)',
    categoryAr: 'حرف',
    categoryEn: 'Letter',
    descriptionAr: 'رفع السبابة قليلاً للأعلى مع إبراز الحركة.',
    descriptionEn: 'Index finger raised slightly higher than usual.',
    imageAsset: 'assets/signs/thaa_emphatic.jpg',
  ),

  // ع
  SignItem(
    label: 'ع',
    nameAr: 'حرف العين',
    nameEn: 'Letter Ain',
    categoryAr: 'حرف',
    categoryEn: 'Letter',
    descriptionAr: 'شكل منحني يشبه رسم حرف ع.',
    descriptionEn: 'Curved hand shape resembling the Arabic Ain.',
    imageAsset: 'assets/signs/ain.jpg',
  ),

  // غ
  SignItem(
    label: 'غ',
    nameAr: 'حرف الغين',
    nameEn: 'Letter Ghayn',
    categoryAr: 'حرف',
    categoryEn: 'Letter',
    descriptionAr: 'مثل العين ولكن مع رفع اليد قليلاً.',
    descriptionEn: 'Same as Ain but slightly raised.',
    imageAsset: 'assets/signs/ghayn.jpg',
  ),

  // ف
  SignItem(
    label: 'ف',
    nameAr: 'حرف الفاء',
    nameEn: 'Letter Faa',
    categoryAr: 'حرف',
    categoryEn: 'Letter',
    descriptionAr: 'ملامسة الإبهام للسبابة مع امتداد باقي الأصابع.',
    descriptionEn: 'Thumb touches index finger while others extend.',
    imageAsset: 'assets/signs/faa.jpg',
  ),

  // ق
  SignItem(
    label: 'ق',
    nameAr: 'حرف القاف',
    nameEn: 'Letter Qaaf',
    categoryAr: 'حرف',
    categoryEn: 'Letter',
    descriptionAr: 'دائرة صغيرة بين الإبهام والسبابة.',
    descriptionEn: 'Small circle between thumb and index finger.',
    imageAsset: 'assets/signs/qaaf.jpg',
  ),

  // ك
  SignItem(
    label: 'ك',
    nameAr: 'حرف الكاف',
    nameEn: 'Letter Kaaf',
    categoryAr: 'حرف',
    categoryEn: 'Letter',
    descriptionAr: 'راحة اليد للأمام مع أصابع مستقيمة.',
    descriptionEn: 'Palm forward with straight fingers.',
    imageAsset: 'assets/signs/kaaf.jpg',
  ),

  // ل
  SignItem(
    label: 'ل',
    nameAr: 'حرف اللام',
    nameEn: 'Letter Laam',
    categoryAr: 'حرف',
    categoryEn: 'Letter',
    descriptionAr: 'شكل L بين الإبهام والسبابة.',
    descriptionEn: 'An L shape between thumb and index finger.',
    imageAsset: 'assets/signs/laam.jpg',
  ),

  // م
  SignItem(
    label: 'م',
    nameAr: 'حرف الميم',
    nameEn: 'Letter Meem',
    categoryAr: 'حرف',
    categoryEn: 'Letter',
    descriptionAr: 'قبض اليد مع وضع الإبهام فوق الأصابع.',
    descriptionEn: 'Closed fist with thumb resting on top.',
    imageAsset: 'assets/signs/meem.jpg',
  ),

  // ن
  SignItem(
    label: 'ن',
    nameAr: 'حرف النون',
    nameEn: 'Letter Noon',
    categoryAr: 'حرف',
    categoryEn: 'Letter',
    descriptionAr: 'مدّ السبابة والوسطى للأمام.',
    descriptionEn: 'Extend index and middle fingers together.',
    imageAsset: 'assets/signs/noon.jpg',
  ),

  // هـ
  SignItem(
    label: 'هـ',
    nameAr: 'حرف الهاء',
    nameEn: 'Letter Haa (soft)',
    categoryAr: 'حرف',
    categoryEn: 'Letter',
    descriptionAr: 'شكل كأس صغير باليد.',
    descriptionEn: 'Cup-shaped gentle hand.',
    imageAsset: 'assets/signs/haa_soft.jpg',
  ),

  // و
  SignItem(
    label: 'و',
    nameAr: 'حرف الواو',
    nameEn: 'Letter Waw',
    categoryAr: 'حرف',
    categoryEn: 'Letter',
    descriptionAr: 'شكل دائرة صغيرة مع رفع اليد.',
    descriptionEn: 'Small circle shape with upward orientation.',
    imageAsset: 'assets/signs/waw.jpg',
  ),

  // ي
  SignItem(
    label: 'ي',
    nameAr: 'حرف الياء',
    nameEn: 'Letter Yaa',
    categoryAr: 'حرف',
    categoryEn: 'Letter',
    descriptionAr: 'رفع الخنصر والإبهام مع قبض باقي الأصابع.',
    descriptionEn: 'Extend pinky and thumb while others fold.',
    imageAsset: 'assets/signs/yaa.jpg',
  ),

 // ة 
  SignItem(
    label: 'ة',
    nameAr: 'حرف التاء المربوطة',
    nameEn: 'Letter Taa Marbuta',
    categoryAr: 'حرف',
    categoryEn: 'Letter',
    descriptionAr: 'شكل مستدير بسيط للدلالة على التاء المربوطة.',
    descriptionEn: 'A small rounded hand shape indicating the tied Taa.',
    imageAsset: 'assets/signs/taa_marbuta.jpg',
  ),

  // Word example
  SignItem(
    label: 'سلام',
    nameAr: 'سلام',
    nameEn: 'Salam',
    categoryAr: 'كلمة',
    categoryEn: 'Word',
    descriptionAr: 'تحية شائعة تعني السلام.',
    descriptionEn: 'A common greeting meaning "peace".',
    imageAsset: 'assets/signs/salam.jpg',
  ),
];


//
// 1) WELCOME / ONBOARDING SCREEN
//

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  void _toggleLanguage() {
    final appState = context.findAncestorStateOfType<_ArslAppState>();
    final currentLang = appState?.language ?? AppLanguage.arabic;
    final newLang = currentLang == AppLanguage.arabic
        ? AppLanguage.english
        : AppLanguage.arabic;

    // 1) Update global language (for all screens)
    appState?.updateLanguage(newLang);

    // 2) Force WelcomeScreen itself to rebuild NOW
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    const ujBlue = Color(0xFF005CA9); // University of Jeddah blue

    final appState = context.findAncestorStateOfType<_ArslAppState>();
    final lang = appState?.language ?? AppLanguage.arabic;
    final isArabic = lang == AppLanguage.arabic;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton.icon(
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    onPressed: _toggleLanguage,
                    icon: const Icon(Icons.language, size: 18),
                    label: Text(
                      isArabic ? 'English' : 'العربية',
                      style: const TextStyle(fontSize: 13),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),
              Expanded(
                child: Center(
                  child: Container(
                    width: size.width * 0.7,
                    height: size.width * 0.7,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(32),
                      color: ujBlue.withOpacity(0.08),
                    ),
                    child: const Icon(
                      Icons.front_hand,
                      size: 120,
                      color: ujBlue,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),
              const Text(
                'ArSL Sign Recognition',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),
              Text(
                tr(
                  context,
                  'تعلم وتعرّف على لغة الإشارة العربية\nوقم بالتعرف على الإشارات باستخدام الكاميرا.',
                  'Learn and explore Arabic Sign Language\nand recognize signs using the camera.',
                ),
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 15),
              ),

              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      vertical: 14,
                      horizontal: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    backgroundColor: ujBlue,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () =>
                      Navigator.pushReplacementNamed(context, '/auth'),
                  icon: const Icon(Icons.arrow_forward_rounded),
                  label: Text(
                    tr(context, 'متابعة', 'Continue'),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),
              TextButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    shape: const RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(24)),
                    ),
                    builder: (_) => const _AboutBottomSheet(),
                  );
                },
                child: Text(tr(context, 'عن التطبيق', 'About the app')),
              ),
            ],
          ),
        ),
      ),
    );
  }
}




class _LanguageToggleButton extends StatelessWidget {
  const _LanguageToggleButton();

  @override
  Widget build(BuildContext context) {
    final appState = context.findAncestorStateOfType<_ArslAppState>();
    final lang = appState?.language ?? AppLanguage.arabic;
    final isArabic = lang == AppLanguage.arabic;

    return TextButton.icon(
      style: TextButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      onPressed: () {
        appState?.updateLanguage(
          isArabic ? AppLanguage.english : AppLanguage.arabic,
        );
      },
      icon: Icon(Icons.language, size: 18),
      label: Text(
        isArabic ? 'English' : 'العربية',
        style: TextStyle(fontSize: 13),
      ),
    );
  }
}



class _AboutBottomSheet extends StatelessWidget {
  const _AboutBottomSheet();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            tr(context, 'عن التطبيق', 'About the app'),
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 12),
          Text(
            tr(
              context,
              'هذا التطبيق يساعدك على التعرف على لغة الإشارة العربية (ArSL) '
              'من خلال التعرف على الإشارات بواسطة الكاميرا، إضافة إلى وضع التدريب '
              'والتذكّر لسجل الإشارات.',
              'This app helps you learn Arabic Sign Language (ArSL) '
              'by recognizing signs through the camera, with practice mode '
              'and a history of recognized signs.',
            ),
          ),
          SizedBox(height: 16),
        ],
      ),
    );
  }
}


//
// 1.1 AUTH CHOICE SCREEN
//

class AuthChoiceScreen extends StatelessWidget {
  const AuthChoiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(tr(context, 'مرحباً بك', 'Welcome')),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 16),
            Text(
              tr(
                context,
                'سجّل دخولك لزيادة تجربتك، أو تابع كضيف.',
                'Sign in to get the full experience, or continue as a guest.',
              ),
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 15),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () {
                  Navigator.pushNamed(context, '/login');
                },
                icon: const Icon(Icons.login),
                label: Text(
                  tr(context, 'تسجيل الدخول', 'Login'),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  Navigator.pushNamed(context, '/signup');
                },
                icon: const Icon(Icons.person_add),
                label: Text(
                  tr(context, 'إنشاء حساب جديد', 'Create new account'),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 16),
            TextButton.icon(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/home');
              },
              icon: const Icon(Icons.person_outline),
              label: Text(tr(context, 'المتابعة كضيف', 'Continue as guest')),
            ),
            const Spacer(),
            Text(
              tr(
                context,
                'بالتسجيل يمكنك حفظ تاريخ الإشارات والتقدم في التدريب.',
                'By creating an account, you can save your sign history and learning progress.',
              ),
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

//
// 1.2 LOGIN SCREEN
//

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            tr(
              context,
              'تم تسجيل الدخول (وهمياً).',
              'Logged in (dummy).',
            ),
          ),
        ),
      );
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(tr(context, 'تسجيل الدخول', 'Login')),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 16),
              Text(
                tr(context, 'مرحباً بعودتك 👋', 'Welcome back 👋'),
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                tr(
                  context,
                  'قم بتسجيل الدخول لمزامنة سجل الإشارات والتقدم في التدريب.',
                  'Sign in to sync your sign history and training progress.',
                ),
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 13),
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _emailCtrl,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: tr(
                    context,
                    'البريد الإلكتروني',
                    'Email',
                  ),
                  prefixIcon: const Icon(Icons.email),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return tr(
                      context,
                      'الرجاء إدخال البريد الإلكتروني',
                      'Please enter your email',
                    );
                  }
                  if (!value.contains('@')) {
                    return tr(
                      context,
                      'بريد إلكتروني غير صالح',
                      'Invalid email address',
                    );
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _passwordCtrl,
                obscureText: _obscure,
                decoration: InputDecoration(
                  labelText: tr(context, 'كلمة المرور', 'Password'),
                  prefixIcon: const Icon(Icons.lock),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _obscure = !_obscure;
                      });
                    },
                    icon: Icon(
                      _obscure ? Icons.visibility_off : Icons.visibility,
                    ),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return tr(
                      context,
                      'الرجاء إدخال كلمة المرور',
                      'Please enter your password',
                    );
                  }
                  if (value.length < 6) {
                    return tr(
                      context,
                      'كلمة المرور يجب أن تكون على الأقل 6 أحرف',
                      'Password must be at least 6 characters',
                    );
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _submit,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Text(tr(context, 'تسجيل الدخول', 'Login')),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/signup');
                },
                child: Text(
                  tr(
                    context,
                    'ليس لديك حساب؟ إنشاء حساب جديد',
                    "Don't have an account? Sign up",
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/home');
                  },
                  child: Text(
                    tr(
                      context,
                      'المتابعة كضيف بدلاً من ذلك',
                      'Continue as guest instead',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//
// 1.3 SIGNUP SCREEN
//

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  bool _obscure = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            tr(
              context,
              'تم إنشاء الحساب (وهمياً).',
              'Account created (dummy).',
            ),
          ),
        ),
      );
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(tr(context, 'إنشاء حساب', 'Sign up')),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 16),
              Text(
                tr(
                  context,
                  'ابدأ رحلتك مع لغة الإشارة ✋',
                  'Start your journey with sign language ✋',
                ),
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                tr(
                  context,
                  'أنشئ حساباً لحفظ تقدمك وسجل الإشارات.',
                  'Create an account to save your progress and sign history.',
                ),
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 13),
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _nameCtrl,
                decoration: InputDecoration(
                  labelText: tr(context, 'الاسم الكامل', 'Full name'),
                  prefixIcon: const Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return tr(
                      context,
                      'الرجاء إدخال الاسم',
                      'Please enter your name',
                    );
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _emailCtrl,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: tr(context, 'البريد الإلكتروني', 'Email'),
                  prefixIcon: const Icon(Icons.email),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return tr(
                      context,
                      'الرجاء إدخال البريد الإلكتروني',
                      'Please enter your email',
                    );
                  }
                  if (!value.contains('@')) {
                    return tr(
                      context,
                      'بريد إلكتروني غير صالح',
                      'Invalid email address',
                    );
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _passwordCtrl,
                obscureText: _obscure,
                decoration: InputDecoration(
                  labelText: tr(context, 'كلمة المرور', 'Password'),
                  prefixIcon: const Icon(Icons.lock),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _obscure = !_obscure;
                      });
                    },
                    icon: Icon(
                      _obscure ? Icons.visibility_off : Icons.visibility,
                    ),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return tr(
                      context,
                      'الرجاء إدخال كلمة المرور',
                      'Please enter a password',
                    );
                  }
                  if (value.length < 6) {
                    return tr(
                      context,
                      'كلمة المرور يجب أن تكون على الأقل 6 أحرف',
                      'Password must be at least 6 characters',
                    );
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _confirmCtrl,
                obscureText: _obscureConfirm,
                decoration: InputDecoration(
                  labelText:
                      tr(context, 'تأكيد كلمة المرور', 'Confirm password'),
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _obscureConfirm = !_obscureConfirm;
                      });
                    },
                    icon: Icon(
                      _obscureConfirm
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return tr(
                      context,
                      'الرجاء تأكيد كلمة المرور',
                      'Please confirm your password',
                    );
                  }
                  if (value != _passwordCtrl.text) {
                    return tr(
                      context,
                      'كلمتا المرور غير متطابقتين',
                      'Passwords do not match',
                    );
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _submit,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Text(tr(context, 'إنشاء حساب', 'Sign up')),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/login');
                },
                child: Text(
                  tr(
                    context,
                    'لديك حساب بالفعل؟ تسجيل الدخول',
                    'Already have an account? Login',
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/home');
                  },
                  child: Text(
                    tr(
                      context,
                      'المتابعة كضيف',
                      'Continue as guest',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//
// 2) HOME DASHBOARD SCREEN
//


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    // build the tile config here, but translation happens per build
    final tiles = [
      _HomeTileData(
        icon: Icons.camera_alt_rounded,
        color: Colors.teal,
        route: '/detect',
        titleAr: 'التعرف الحي',
        titleEn: 'Live detection',
        subtitleAr: 'استخدم الكاميرا للتعرف على الإشارة',
        subtitleEn: 'Use the camera to recognize signs',
      ),
      _HomeTileData(
        icon: Icons.school_rounded,
        color: Colors.deepPurple,
        route: '/practice',
        titleAr: 'تعلم الإشارات',
        titleEn: 'Practice signs',
        subtitleAr: 'تعلّم الحروف والكلمات بلغة الإشارة العربية',
        subtitleEn: 'Learn letters and words in Arabic Sign Language',
      ),
      _HomeTileData(
        icon: Icons.history_rounded,
        color: Colors.indigo,
        route: '/history',
        titleAr: 'السجل',
        titleEn: 'History',
        subtitleAr: 'عرض الإشارات التي تم التعرف عليها',
        subtitleEn: 'View previously recognized signs',
      ),
      _HomeTileData(
        icon: Icons.settings_rounded,
        color: Colors.orange,
        route: '/settings',
        titleAr: 'الإعدادات',
        titleEn: 'Settings',
        subtitleAr: 'اللغة، الوضع الداكن، والمزيد',
        subtitleEn: 'Language, dark mode, and more',
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('ArSL Sign Recognition'),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.person),
            tooltip: tr(context, 'الملف الشخصي', 'Profile'),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Align(
                alignment: Alignment.center,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tr(context, 'مرحباً 👋', 'Hi 👋'),
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      tr(
                        context,
                        'اختر ما تريد القيام به اليوم',
                        'Choose what you want to do today',
                      ),
                      style: const TextStyle(fontSize: 15),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Tiles
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: tiles.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisExtent: 170,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemBuilder: (context, index) {
                  final tile = tiles[index];

                  final title =
                      tr(context, tile.titleAr, tile.titleEn); // translated
                  final subtitle = tr(
                    context,
                    tile.subtitleAr,
                    tile.subtitleEn,
                  );

                  return _HomeTile(
                    title: title,
                    subtitle: subtitle,
                    icon: tile.icon,
                    color: tile.color,
                    onTap: tile.route == null
                        ? null
                        : () async {
                            if (tile.route == '/settings') {
                              await Navigator.pushNamed(context, tile.route!);
                              setState(() {}); // forces rebuild with new lang
                            } else {
                              Navigator.pushNamed(context, tile.route!);
                            }
                          },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HomeTileData {
  final String titleAr;
  final String titleEn;
  final String subtitleAr;
  final String subtitleEn;
  final IconData icon;
  final Color color;
  final String? route;

  _HomeTileData({
    required this.titleAr,
    required this.titleEn,
    required this.subtitleAr,
    required this.subtitleEn,
    required this.icon,
    required this.color,
    this.route,
  });
}

class _HomeTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;

  const _HomeTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Ink(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: theme.colorScheme.surface,
          boxShadow: isDark
              ? []
              : [
                  BoxShadow(
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                    color: Colors.black.withOpacity(0.08),
                  ),
                ],
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 22,
              backgroundColor: color.withOpacity(0.1),
              child: Icon(icon, color: color, size: 24),
            ),
            const Spacer(),
            Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.textTheme.bodySmall?.color?.withOpacity(0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


//
// 3) SETTINGS SCREEN
//

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _showTips = true;
  bool _enableHaptics = true;

  @override
  Widget build(BuildContext context) {
    final appState = context.findAncestorStateOfType<_ArslAppState>();

    final isDark = appState?.themeMode == ThemeMode.dark;
    final fontScale = appState?.textScaleFactor ?? 1.0;
    final lang = appState?.language ?? AppLanguage.arabic;

    return Scaffold(
      appBar: AppBar(
        title: Text(tr(context, 'الإعدادات', 'Settings')),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Language section
          Text(
            tr(context, 'اللغة', 'Language'),
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          RadioListTile<AppLanguage>(
            title: const Text('العربية'),
            value: AppLanguage.arabic,
            groupValue: lang,
            onChanged: (value) {
              if (value != null) {
                appState?.updateLanguage(value);
                setState(() {});
              }
            },
          ),
          RadioListTile<AppLanguage>(
            title: const Text('English'),
            value: AppLanguage.english,
            groupValue: lang,
            onChanged: (value) {
              if (value != null) {
                appState?.updateLanguage(value);
                setState(() {});
              }
            },
          ),
          const SizedBox(height: 24),

          // Appearance
          Text(
            tr(context, 'المظهر', 'Appearance'),
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          SwitchListTile(
            title: Text(tr(context, 'الوضع الداكن', 'Dark mode')),
            subtitle: Text(
              tr(context, 'تفعيل الثيم الداكن للتطبيق',
                  'Enable dark theme for the app'),
            ),
            value: isDark,
            onChanged: (value) {
              appState?.updateThemeMode(
                value ? ThemeMode.dark : ThemeMode.light,
              );
              setState(() {});
            },
          ),

          const SizedBox(height: 16),
          Text(
            tr(context, 'حجم الخط', 'Font size'),
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Slider(
                value: fontScale,
                min: 0.8,
                max: 1.4,
                divisions: 6,
                label: '${(fontScale * 100).round()}٪',
                onChanged: (value) {
                  appState?.updateTextScale(value);
                  setState(() {});
                },
              ),
              Text(
                tr(
                  context,
                  'حجم الخط الحالي: ${(fontScale * 100).round()}٪',
                  'Current font size: ${(fontScale * 100).round()}%',
                ),
                style: const TextStyle(fontSize: 13),
              ),
            ],
          ),

          const SizedBox(height: 24),
          Text(
            tr(context, 'التجربة', 'Experience'),
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          SwitchListTile(
            title: Text(
              tr(context, 'إظهار النصائح والإرشادات',
                  'Show tips and guidance'),
            ),
            subtitle: Text(
              tr(
                context,
                'عرض نصائح تحت الكاميرا وفي شاشة التدريب',
                'Show tips under the camera and in training screens',
              ),
            ),
            value: _showTips,
            onChanged: (value) {
              setState(() {
                _showTips = value;
              });
            },
          ),
          SwitchListTile(
            title: Text(
              tr(context, 'تفعيل الاهتزاز (Haptics)', 'Enable vibration'),
            ),
            subtitle: Text(
              tr(
                context,
                'للتغذية الراجعة عند التعرّف على إشارة',
                'For feedback when a sign is recognized',
              ),
            ),
            value: _enableHaptics,
            onChanged: (value) {
              setState(() {
                _enableHaptics = value;
              });
            },
          ),

          const SizedBox(height: 24),
          Text(
            tr(context, 'حول التطبيق', 'About'),
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          ListTile(
            leading: const Icon(Icons.star_border),
            title: Text(
              tr(
                context,
                '💙 تم تطويره بواسطة طلاب علوم الحاسب من جامعة جدة',
                '💙 Developed by Computer Science students from University of Jeddah',
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: Text(tr(context, 'إصدار التطبيق', 'App version')),
            subtitle: const Text('1.0.0 (beta)'),
          ),
        ],
      ),
    );
  }
}

//
// 4) LIVE DETECTION SCREEN
//

class LiveDetectionScreen extends StatefulWidget {
  const LiveDetectionScreen({super.key});

  @override
  State<LiveDetectionScreen> createState() => _LiveDetectionScreenState();
}

class _LiveDetectionScreenState extends State<LiveDetectionScreen> {
  CameraController? _controller;
  Future<void>? _initializeControllerFuture;

  bool isDetecting = false;
  String? currentSignLabel;
  String? currentSignName;
  double? confidence;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    try {
      final cameras = await availableCameras();
      final backCamera = cameras.firstWhere(
        (c) => c.lensDirection == CameraLensDirection.back,
        orElse: () => cameras.first,
      );

      _controller = CameraController(
        backCamera,
        ResolutionPreset.medium,
        enableAudio: false,
      );

      _initializeControllerFuture = _controller!.initialize();
      setState(() {});
    } catch (e) {
      debugPrint('Error initializing camera: $e');
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  void _toggleDetection() {
    setState(() {
      isDetecting = !isDetecting;
      if (!isDetecting) {
        currentSignLabel = null;
        currentSignName = null;
        confidence = null;
      } else {
        // Dummy recognition
        currentSignLabel = 'أ';
        currentSignName = 'Letter Alef';
        confidence = 0.92;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final resultCard = Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: currentSignLabel == null
            ? Text(
                tr(
                  context,
                  'لا توجد نتيجة بعد.\nضع يدك أمام الكاميرا لبدء التعرف على الإشارة.',
                  'No result yet.\nPlace your hand in front of the camera to start recognition.',
                ),
              )
            : Row(
                children: [
                  CircleAvatar(
                    radius: 26,
                    backgroundColor: Colors.teal.withOpacity(0.12),
                    child: Text(
                      currentSignLabel!,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          currentSignName ?? '',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (confidence != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            tr(
                              context,
                              'الدقة التقريبية: ${(confidence! * 100).toStringAsFixed(1)}٪',
                              'Approx. confidence: ${(confidence! * 100).toStringAsFixed(1)}%',
                            ),
                            style: const TextStyle(fontSize: 13),
                          ),
                          const SizedBox(height: 8),
                          LinearProgressIndicator(
                            value: confidence!.clamp(0, 1),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          tr(context, 'التعرف الحي على الإشارة', 'Live sign detection'),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: _controller == null
                    ? const Center(child: CircularProgressIndicator())
                    : FutureBuilder(
                        future: _initializeControllerFuture,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            return Stack(
                              fit: StackFit.expand,
                              children: [
                                CameraPreview(_controller!),
                                Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: CustomPaint(
                                    painter: _CornersPainter(),
                                  ),
                                ),
                              ],
                            );
                          } else if (snapshot.hasError) {
                            return Center(
                              child: Text(
                                tr(
                                  context,
                                  'حدث خطأ في تشغيل الكاميرا:\n${snapshot.error}',
                                  'An error occurred while starting the camera:\n${snapshot.error}',
                                ),
                                textAlign: TextAlign.center,
                              ),
                            );
                          } else {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                        },
                      ),
              ),
            ),
          ),
          resultCard,
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                const Icon(Icons.info_outline, size: 18),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    tr(
                      context,
                      'تأكد من وجود إضاءة جيدة، وأن اليد ظاهرة بوضوح داخل إطار الكاميرا.',
                      'Make sure there is good lighting and your hand is clearly visible within the frame.',
                    ),
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _controller == null ? null : _toggleDetection,
                icon: Icon(
                  isDetecting
                      ? Icons.stop_circle_outlined
                      : Icons.play_arrow_rounded,
                ),
                label: Text(
                  tr(
                    context,
                    isDetecting ? 'إيقاف التعرف' : 'بدء التعرف',
                    isDetecting ? 'Stop detection' : 'Start detection',
                  ),
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CornersPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.tealAccent
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    const cornerLength = 24.0;

    // top-left
    canvas.drawLine(
      const Offset(0, 0),
      const Offset(cornerLength, 0),
      paint,
    );
    canvas.drawLine(
      const Offset(0, 0),
      const Offset(0, cornerLength),
      paint,
    );

    // top-right
    canvas.drawLine(
      Offset(size.width, 0),
      Offset(size.width - cornerLength, 0),
      paint,
    );
    canvas.drawLine(
      Offset(size.width, 0),
      Offset(size.width, cornerLength),
      paint,
    );

    // bottom-left
    canvas.drawLine(
      Offset(0, size.height),
      Offset(0, size.height - cornerLength),
      paint,
    );
    canvas.drawLine(
      Offset(0, size.height),
      Offset(cornerLength, size.height),
      paint,
    );

    // bottom-right
    canvas.drawLine(
      Offset(size.width, size.height),
      Offset(size.width - cornerLength, size.height),
      paint,
    );
    canvas.drawLine(
      Offset(size.width, size.height),
      Offset(size.width, size.height - cornerLength),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

//
// 5) PRACTICE SIGNS SCREEN
//

class PracticeScreen extends StatelessWidget {
  const PracticeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(tr(context, 'تدريب الإشارات', 'Practice signs')),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: mockSigns.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          final sign = mockSigns[index];
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: ListTile(
              leading: CircleAvatar(
                radius: 22,
                backgroundColor: Colors.teal.withOpacity(0.1),
                child: Text(
                  sign.label,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              title: Text(tr(context, sign.nameAr, sign.nameEn)),
              subtitle: Text(tr(context, sign.categoryAr, sign.categoryEn)),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                Navigator.pushNamed(
                  context,
                  SignDetailScreen.routeName,
                  arguments: sign,
                );
              },
            ),
          );
        },
      ),
    );
  }
}

//
// 6) HISTORY SCREEN
//

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final history = [
      {'time': tr(context, 'اليوم - 10:30 ص', 'Today - 10:30 AM'), 'sign': mockSigns[0]},
      {'time': tr(context, 'اليوم - 10:25 ص', 'Today - 10:25 AM'), 'sign': mockSigns[1]},
      {'time': tr(context, 'أمس - 5:15 م', 'Yesterday - 5:15 PM'), 'sign': mockSigns[2]},
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(tr(context, 'سجل الإشارات', 'Sign history')),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: history.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          final item = history[index];
          final sign = item['sign'] as SignItem;
          final time = item['time'] as String;

          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: ListTile(
              leading: CircleAvatar(
                radius: 22,
                backgroundColor: Colors.indigo.withOpacity(0.1),
                child: Text(
                  sign.label,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              title: Text('${sign.nameAr} / ${sign.nameEn}'),
              subtitle: Text(time),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                Navigator.pushNamed(
                  context,
                  SignDetailScreen.routeName,
                  arguments: sign,
                );
              },
            ),
          );
        },
      ),
    );
  }
}

//
// 7) SIGN DETAIL SCREEN
//

class SignDetailScreen extends StatelessWidget {
  static const routeName = '/sign-detail';

  final SignItem sign;

  const SignDetailScreen({super.key, required this.sign});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text('${sign.nameAr} / ${sign.nameEn}'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: size.width,
              height: size.width * 0.6,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                color: Colors.grey.shade200,
              ),
              child: const Center(
                child: Icon(
                  Icons.image_outlined,
                  size: 56,
                  color: Colors.grey,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor: Colors.teal.withOpacity(0.1),
                  child: Text(
                    sign.label,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tr(context, sign.nameAr, sign.nameEn),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      tr(context, sign.descriptionAr, sign.descriptionEn),
                      style: const TextStyle(fontSize: 13, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              tr(context, sign.descriptionAr, sign.descriptionEn),
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 16),
            Text(
              tr(context, 'نصائح للتطبيق:', 'Tips for practice:'),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              tr(
                context,
                '• تأكد من أن اليد واضحة ضمن الكاميرا.\n'
                '• كرر الإشارة أكثر من مرة لتثبيت الحركة.\n'
                '• حاول تقليد السرعة الصحيحة ولغة الجسد.',
                '• Make sure your hand is clearly visible in the camera.\n'
                '• Repeat the sign multiple times to memorize it.\n'
                '• Try to match the correct speed and body language.',
              ),
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      tr(
                        context,
                        'سيتم ربط هذا الزر بوضع التدريب بالكاميرا لاحقاً.',
                        'This button will be linked to camera training mode later.',
                      ),
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.front_hand),
              label: Text(
                tr(context, 'جرّب هذه الإشارة الآن', 'Try this sign now'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
