import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/question.dart';
import '../data/quiz_data.dart';

class QuizState extends ChangeNotifier {
  String? _selectedCategory;
  List<Question> _currentQuestions = [];
  int _currentQuestionIndex = 0;
  final Map<int, int> _selectedAnswers =
      {}; // Maps questionIndex -> selectedOptionIndex
  bool _isSubmitted = false;

  // Timer settings
  static const int questionTimeLimit = 30; // 30 seconds per question
  int _timeRemaining = questionTimeLimit;
  Timer? _timer;

  // Getters
  String? get selectedCategory => _selectedCategory;
  List<Question> get currentQuestions => _currentQuestions;
  int get currentQuestionIndex => _currentQuestionIndex;
  Map<int, int> get selectedAnswers => _selectedAnswers;
  bool get isSubmitted => _isSubmitted;
  int get timeRemaining => _timeRemaining;
  bool get hasActiveQuiz => _selectedCategory != null;

  Question get currentQuestion => _currentQuestions[_currentQuestionIndex];

  // Helper getters
  int get totalQuestions => _currentQuestions.length;
  int get totalAnswered => _selectedAnswers.length;
  int get correctAnswersCount {
    int score = 0;
    for (int i = 0; i < _currentQuestions.length; i++) {
      if (_selectedAnswers[i] == _currentQuestions[i].correctOptionIndex) {
        score++;
      }
    }
    return score;
  }

  // Setters & Actions
  void startQuiz(String category) {
    _selectedCategory = category;
    _currentQuestions = QuizData.questions
        .where((q) => q.category == category)
        .toList();
    _currentQuestionIndex = 0;
    _selectedAnswers.clear();
    _isSubmitted = false;
    _timeRemaining = questionTimeLimit;

    _startTimer();
    notifyListeners();
  }

  void selectOption(int optionIndex) {
    if (_isSubmitted) return;
    _selectedAnswers[_currentQuestionIndex] = optionIndex;
    notifyListeners();
  }

  void nextQuestion() {
    if (_currentQuestionIndex < _currentQuestions.length - 1) {
      _currentQuestionIndex++;
      _resetQuestionTimer();
      notifyListeners();
    }
  }

  void previousQuestion() {
    if (_currentQuestionIndex > 0) {
      _currentQuestionIndex--;
      _resetQuestionTimer();
      notifyListeners();
    }
  }

  void submitQuiz() {
    _cancelTimer();
    _isSubmitted = true;
    notifyListeners();
  }

  void resetQuiz() {
    _cancelTimer();
    _selectedCategory = null;
    _currentQuestions = [];
    _currentQuestionIndex = 0;
    _selectedAnswers.clear();
    _isSubmitted = false;
    _timeRemaining = questionTimeLimit;
    notifyListeners();
  }

  // Timer logic
  void _startTimer() {
    _cancelTimer();
    _timeRemaining = questionTimeLimit;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeRemaining > 0) {
        _timeRemaining--;
        notifyListeners();
      } else {
        _handleQuestionTimeout();
      }
    });
  }

  void _resetQuestionTimer() {
    _timeRemaining = questionTimeLimit;
    // Keep the periodic timer ticking, just reset the counter
  }

  void _cancelTimer() {
    _timer?.cancel();
    _timer = null;
  }

  void _handleQuestionTimeout() {
    // If the question timed out and user hasn't selected an option, it will be left blank
    if (_currentQuestionIndex < _currentQuestions.length - 1) {
      nextQuestion();
    } else {
      // Auto-submit if the timer runs out on the last question
      submitQuiz();
    }
  }

  @override
  void dispose() {
    _cancelTimer();
    super.dispose();
  }
}
