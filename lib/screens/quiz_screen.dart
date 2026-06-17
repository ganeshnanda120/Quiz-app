import 'package:flutter/material.dart';
import '../models/quiz_state.dart';
import '../theme/theme.dart';

class QuizScreen extends StatelessWidget {
  final QuizState quizState;

  const QuizScreen({super.key, required this.quizState});

  void _showExitDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Exit Quiz?'),
        content: const Text(
          'Are you sure you want to exit? Your progress in this quiz will be lost.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(color: AppTheme.textSecondary),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // close dialog
              quizState.resetQuiz(); // reset state to home
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.error,
              foregroundColor: Colors.white,
            ),
            child: const Text('Exit'),
          ),
        ],
      ),
    );
  }

  void _showSubmitDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Submit Quiz?'),
        content: Text(
          'You have answered ${quizState.totalAnswered} out of ${quizState.totalQuestions} questions. '
          'Do you want to submit and see your score?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(color: AppTheme.textSecondary),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // close dialog
              quizState.submitQuiz(); // submit state
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.success,
              foregroundColor: Colors.white,
            ),
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final currentQ = quizState.currentQuestion;
    final currentIndex = quizState.currentQuestionIndex;
    final totalQ = quizState.totalQuestions;
    final selectedOption = quizState.selectedAnswers[currentIndex];
    final progress = (currentIndex + 1) / totalQ;

    // Timer color adjustments based on time remaining
    Color timerColor = AppTheme.success;
    if (quizState.timeRemaining <= 10) {
      timerColor = AppTheme.warning;
    }
    if (quizState.timeRemaining <= 5) {
      timerColor = AppTheme.error;
    }

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 800),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Top Action Bar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon:
                        const Icon(Icons.arrow_back_rounded, color: Colors.white),
                    onPressed: () => _showExitDialog(context),
                    tooltip: 'Back to Categories',
                  ),
                  Text(
                    quizState.selectedCategory ?? 'Quiz',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  // Animated Timer Widget
                  Container(
                    width: 44,
                    height: 44,
                    alignment: Alignment.center,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        CircularProgressIndicator(
                          value: quizState.timeRemaining /
                              QuizState.questionTimeLimit,
                          strokeWidth: 4,
                          valueColor: AlwaysStoppedAnimation<Color>(timerColor),
                          backgroundColor: Colors.white.withValues(alpha: 0.08),
                        ),
                        Text(
                          '${quizState.timeRemaining}',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: timerColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Linear Progress Bar
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 8,
                      backgroundColor: Colors.white.withValues(alpha: 0.05),
                      valueColor:
                          const AlwaysStoppedAnimation<Color>(AppTheme.primary),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Question ${currentIndex + 1} of $totalQ',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppTheme.textSecondary,
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                      Text(
                        '${((progress) * 100).toInt()}% Done',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppTheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Question Navigation Dots / Indicator Row
              Wrap(
                spacing: 8,
                runSpacing: 8,
                alignment: WrapAlignment.center,
                children: List.generate(totalQ, (idx) {
                  final isCurrent = idx == currentIndex;
                  final isAnswered = quizState.selectedAnswers.containsKey(idx);

                  Color dotColor = Colors.white.withValues(alpha: 0.1);
                  if (isCurrent) {
                    dotColor = AppTheme.primary;
                  } else if (isAnswered) {
                    dotColor = AppTheme.primary.withValues(alpha: 0.4);
                  }

                  return InkWell(
                    onTap: () {},
                    borderRadius: BorderRadius.circular(4),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: isCurrent ? 28 : 20,
                      height: 8,
                      decoration: BoxDecoration(
                        color: dotColor,
                        borderRadius: BorderRadius.circular(4),
                        border: isCurrent
                            ? Border.all(
                                color: Colors.white.withValues(alpha: 0.3),
                                width: 1,
                              )
                            : null,
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 24),

              // Animated Switcher for smooth question slide/fade
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder:
                      (Widget child, Animation<double> animation) {
                    return FadeTransition(
                      opacity: animation,
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0.08, 0.0),
                          end: Offset.zero,
                        ).animate(animation),
                        child: child,
                      ),
                    );
                  },
                  child: Container(
                    key: ValueKey<int>(currentIndex),
                    decoration: AppTheme.glassDecoration(),
                    padding: const EdgeInsets.all(24),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            currentQ.text,
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium
                                ?.copyWith(
                                  fontSize: size.width < 500 ? 18 : 22,
                                  fontWeight: FontWeight.bold,
                                  height: 1.4,
                                ),
                          ),
                          const SizedBox(height: 32),
                          // Options List
                          ...List.generate(currentQ.options.length, (optIdx) {
                            final isSelected = selectedOption == optIdx;
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: _OptionTile(
                                optionText: currentQ.options[optIdx],
                                indexLabel: String.fromCharCode(65 + optIdx), // A, B, C, D
                                isSelected: isSelected,
                                onTap: () => quizState.selectOption(optIdx),
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Bottom Navigation Controls
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Previous Button
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: currentIndex > 0
                          ? () => quizState.previousQuestion()
                          : null,
                      icon: const Icon(Icons.chevron_left_rounded),
                      label: const Text('Previous'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        foregroundColor: Colors.white,
                        side: BorderSide(
                          color: Colors.white.withValues(alpha: 0.1),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Next / Submit Button
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: currentIndex == totalQ - 1
                            ? const LinearGradient(
                                colors: [AppTheme.success, Color(0xFF059669)],
                              )
                            : AppTheme.accentGradient,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: (currentIndex == totalQ - 1
                                    ? AppTheme.success
                                    : AppTheme.primary)
                                .withValues(alpha: 0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          )
                        ],
                      ),
                      child: ElevatedButton.icon(
                        onPressed: () {
                          if (currentIndex == totalQ - 1) {
                            _showSubmitDialog(context);
                          } else {
                            quizState.nextQuestion();
                          }
                        },
                        icon: Icon(
                          currentIndex == totalQ - 1
                              ? Icons.check_circle_outline_rounded
                              : Icons.chevron_right_rounded,
                        ),
                        label: Text(currentIndex == totalQ - 1 ? 'Submit' : 'Next'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          foregroundColor: Colors.white,
                          shadowColor: Colors.transparent,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OptionTile extends StatefulWidget {
  final String optionText;
  final String indexLabel;
  final bool isSelected;
  final VoidCallback onTap;

  const _OptionTile({
    required this.optionText,
    required this.indexLabel,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<_OptionTile> createState() => _OptionTileState();
}

class _OptionTileState extends State<_OptionTile> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        decoration: BoxDecoration(
          color: widget.isSelected
              ? AppTheme.primary.withValues(alpha: 0.15)
              : _isHovered
                  ? Colors.white.withValues(alpha: 0.05)
                  : Colors.white.withValues(alpha: 0.02),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: widget.isSelected
                ? AppTheme.primary
                : _isHovered
                    ? Colors.white.withValues(alpha: 0.3)
                    : Colors.white.withValues(alpha: 0.08),
            width: widget.isSelected ? 2 : 1,
          ),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: widget.onTap,
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                children: [
                  // Option letter indicator (A, B, C, D)
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    width: 32,
                    height: 32,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: widget.isSelected
                          ? AppTheme.primary
                          : Colors.white.withValues(alpha: 0.08),
                    ),
                    child: Text(
                      widget.indexLabel,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: widget.isSelected
                            ? Colors.white
                            : AppTheme.textSecondary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      widget.optionText,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: widget.isSelected
                            ? FontWeight.w600
                            : FontWeight.normal,
                        color: widget.isSelected
                            ? Colors.white
                            : AppTheme.textPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
