import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:device_preview/device_preview.dart';

import 'models/lesson.dart';
import 'screens/ai_assistant_screen.dart';
import 'screens/home_screen.dart';
import 'screens/lessons_screen.dart';
import 'theme/app_theme.dart';
import 'widgets/bottom_navigation_bar.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Loads the Gemini API key from the local .env file, which is
  // excluded from version control. Missing the file entirely is
  // handled gracefully so the app still runs — Sensei just won't
  // be able to answer until a key is added.
  try {
    await dotenv.load(fileName: "assets/.env");
  } catch (_) {
    dotenv.testLoad(mergeWith: {'GEMINI_API_KEY': ''});
  }

  runApp(
    DevicePreview(
      enabled: !const bool.fromEnvironment('dart.vm.product'),
      builder: (context) => const KaishiApp(),
    ),
  );
}

class KaishiApp extends StatelessWidget {
  const KaishiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kaishi',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      useInheritedMediaQuery: true,
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      home: const MainScreen(),
    );
  }
}

/// Hosts the three Kaishi screens (Home, Lessons, Sensei) behind
/// the shared BottomNavigationBar, and carries the small bits of
/// state they need to share: which tab is active, which lesson was
/// last opened, and that lesson's title
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _activeTab = 0;
  String? _pendingLessonId;
  String _currentLessonTitle = 'Introduction to Hiragana';

  final GlobalKey<HomeScreenState> _homeKey = GlobalKey<HomeScreenState>();

  void _handleNavigate(int tabIndex, {String? lessonId}) {
    setState(() {
      _activeTab = tabIndex;
      if (lessonId != null) _pendingLessonId = lessonId;
    });
    if (tabIndex == 0) {
      _homeKey.currentState?.refresh();
    }
  }

  void _handleActiveLessonChanged(Lesson lesson) {
    if (lesson.title == _currentLessonTitle) return;
    // Defer to avoid calling setState during LessonsScreen's own build.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      setState(() => _currentLessonTitle = lesson.title);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: IndexedStack(
          index: _activeTab,
          children: [
            HomeScreen(key: _homeKey, onNavigate: _handleNavigate),
            LessonsScreen(
              initialLessonId: _pendingLessonId,
              onActiveLessonChanged: _handleActiveLessonChanged,
            ),
            AIAssistantScreen(currentLessonTitle: _currentLessonTitle),
          ],
        ),
      ),
      bottomNavigationBar: KaishiBottomNavigationBar(
        activeTab: _activeTab,
        onTap: (index) => _handleNavigate(index),
      ),
    );
  }
}
