import 'package:flutter/material.dart';
import 'models/quiz_state.dart';
import 'theme/theme.dart';
import 'screens/category_screen.dart';
import 'screens/quiz_screen.dart';
import 'screens/result_screen.dart';

void main() {
  runApp(const QuizApp());
}

class QuizApp extends StatefulWidget {
  const QuizApp({super.key});

  @override
  State<QuizApp> createState() => _QuizAppState();
}

class _QuizAppState extends State<QuizApp> {
  late final QuizState _quizState;

  @override
  void initState() {
    super.initState();
    _quizState = QuizState();
  }

  @override
  void dispose() {
    _quizState.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quiz Quest',
      theme: AppTheme.darkTheme,
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Container(
          decoration: const BoxDecoration(gradient: AppTheme.bgGradient),
          child: SafeArea(
            child: ListenableBuilder(
              listenable: _quizState,
              builder: (context, child) {
                return AnimatedSwitcher(
                  duration: const Duration(milliseconds: 400),
                  transitionBuilder:
                      (Widget child, Animation<double> animation) {
                        return FadeTransition(opacity: animation, child: child);
                      },
                  child: _buildActiveScreen(),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActiveScreen() {
    if (_quizState.isSubmitted) {
      return ResultScreen(
        key: const ValueKey('ResultScreen'),
        quizState: _quizState,
      );
    } else if (_quizState.hasActiveQuiz) {
      return QuizScreen(
        key: const ValueKey('QuizScreen'),
        quizState: _quizState,
      );
    } else {
      return CategoryScreen(
        key: const ValueKey('CategoryScreen'),
        quizState: _quizState,
      );
    }
  }
}
