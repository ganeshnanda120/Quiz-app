import 'package:flutter/material.dart';
import '../models/quiz_state.dart';
import '../theme/theme.dart';

class ResultScreen extends StatefulWidget {
  final QuizState quizState;

  const ResultScreen({super.key, required this.quizState});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scoreAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );

    final double targetProgress = widget.quizState.totalQuestions > 0
        ? widget.quizState.correctAnswersCount / widget.quizState.totalQuestions
        : 0.0;

    _scoreAnimation = Tween<double>(begin: 0.0, end: targetProgress).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  String _getPerformanceTitle(double ratio) {
    if (ratio == 1.0) return 'Perfect Score!';
    if (ratio >= 0.8) return 'Outstanding!';
    if (ratio >= 0.6) return 'Great Job!';
    if (ratio >= 0.4) return 'Good Effort!';
    return 'Keep Practicing!';
  }

  String _getPerformanceSubtitle(double ratio) {
    if (ratio == 1.0) return 'You have mastered this topic completely.';
    if (ratio >= 0.8) return 'Amazing knowledge! You are almost there.';
    if (ratio >= 0.6) return 'You have a solid understanding of these basics.';
    if (ratio >= 0.4) {
      return 'A decent try. Review your mistakes and try again.';
    }
    return 'Take some time to study and boost your score next time!';
  }

  Color _getPerformanceColor(double ratio) {
    if (ratio >= 0.8) return AppTheme.success;
    if (ratio >= 0.5) return AppTheme.secondary;
    if (ratio >= 0.3) return AppTheme.warning;
    return AppTheme.error;
  }

  @override
  Widget build(BuildContext context) {
    final state = widget.quizState;
    final totalQ = state.totalQuestions;
    final correctCount = state.correctAnswersCount;
    final scoreRatio = totalQ > 0 ? correctCount / totalQ : 0.0;

    final perfColor = _getPerformanceColor(scoreRatio);
    final title = _getPerformanceTitle(scoreRatio);
    final subtitle = _getPerformanceSubtitle(scoreRatio);

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 800),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header title
              Text(
                'Quiz Results',
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),

              // Animated Score Circle & Details Card
              Container(
                decoration: AppTheme.glassDecoration(),
                padding: const EdgeInsets.all(32),
                child: Column(
                  children: [
                    // Score Circle
                    AnimatedBuilder(
                      animation: _scoreAnimation,
                      builder: (context, child) {
                        final animatedRatio = _scoreAnimation.value;
                        return SizedBox(
                          width: 160,
                          height: 160,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              // Glow background
                              Container(
                                width: 140,
                                height: 140,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: perfColor.withValues(alpha: 0.15),
                                      blurRadius: 32,
                                      spreadRadius: 8,
                                    ),
                                  ],
                                ),
                              ),
                              // Circular track
                              CircularProgressIndicator(
                                value: 1.0,
                                strokeWidth: 12,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white.withValues(alpha: 0.04),
                                ),
                              ),
                              // Circular progress indicator (actual animated score)
                              CircularProgressIndicator(
                                value: animatedRatio,
                                strokeWidth: 12,
                                strokeCap: StrokeCap.round,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  perfColor,
                                ),
                              ),
                              // Text in circle
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '${(animatedRatio * 100).toInt()}%',
                                    style: TextStyle(
                                      fontSize: 36,
                                      fontWeight: FontWeight.w900,
                                      color: perfColor,
                                      letterSpacing: -1,
                                    ),
                                  ),
                                  Text(
                                    '$correctCount / $totalQ Correct',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 28),

                    // Performance Status
                    Text(
                      title,
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium
                          ?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: perfColor,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),

                    // Navigation Action Buttons
                    Row(
                      children: [
                        // Try Again Button
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () =>
                                state.startQuiz(state.selectedCategory!),
                            icon: const Icon(Icons.refresh_rounded),
                            label: const Text('Try Again'),
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
                        // Choose Category Button
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: AppTheme.accentGradient,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: ElevatedButton.icon(
                              onPressed: () => state.resetQuiz(),
                              icon: const Icon(Icons.home_rounded),
                              label: const Text('Home'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                foregroundColor: Colors.white,
                                shadowColor: Colors.transparent,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
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
              const SizedBox(height: 40),

              // Question Breakdown Section Header
              Text(
                'Review Your Answers',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.2,
                    ),
              ),
              const SizedBox(height: 16),

              // Breakdown cards
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: totalQ,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  final question = state.currentQuestions[index];
                  final selectedIdx = state.selectedAnswers[index];
                  final isCorrect = selectedIdx == question.correctOptionIndex;
                  final isSkipped = selectedIdx == null;

                  return Container(
                    decoration: AppTheme.glassDecoration(),
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Question Header (Correct / Wrong tag)
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: isSkipped
                                    ? AppTheme.warning.withValues(alpha: 0.1)
                                    : isCorrect
                                        ? AppTheme.success.withValues(alpha: 0.1)
                                        : AppTheme.error.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    isSkipped
                                        ? Icons.hourglass_empty_rounded
                                        : isCorrect
                                            ? Icons.check_circle_outline_rounded
                                            : Icons.highlight_off_rounded,
                                    size: 16,
                                    color: isSkipped
                                        ? AppTheme.warning
                                        : isCorrect
                                            ? AppTheme.success
                                            : AppTheme.error,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    isSkipped
                                        ? 'Timed Out / Skipped'
                                        : isCorrect
                                            ? 'Correct'
                                            : 'Incorrect',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: isSkipped
                                          ? AppTheme.warning
                                          : isCorrect
                                              ? AppTheme.success
                                              : AppTheme.error,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Spacer(),
                            Text(
                              'Q${index + 1}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppTheme.textMuted,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Question Text
                        Text(
                          question.text,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Options listing in result mode
                        ...List.generate(question.options.length, (optIdx) {
                          final isThisSelected = selectedIdx == optIdx;
                          final isThisCorrect =
                              question.correctOptionIndex == optIdx;

                          Color tileBg = Colors.white.withValues(alpha: 0.01);
                          Color borderC = Colors.white.withValues(alpha: 0.05);
                          IconData? trailingIcon;
                          Color? iconC;

                          if (isThisCorrect) {
                            tileBg = AppTheme.success.withValues(alpha: 0.1);
                            borderC = AppTheme.success.withValues(alpha: 0.4);
                            trailingIcon = Icons.check_circle_rounded;
                            iconC = AppTheme.success;
                          } else if (isThisSelected && !isCorrect) {
                            tileBg = AppTheme.error.withValues(alpha: 0.1);
                            borderC = AppTheme.error.withValues(alpha: 0.4);
                            trailingIcon = Icons.cancel_rounded;
                            iconC = AppTheme.error;
                          }

                          return Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: tileBg,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: borderC, width: 1),
                            ),
                            child: Row(
                              children: [
                                Text(
                                  String.fromCharCode(65 + optIdx),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: isThisCorrect
                                        ? AppTheme.success
                                        : isThisSelected
                                            ? AppTheme.error
                                            : AppTheme.textSecondary,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    question.options[optIdx],
                                    style: TextStyle(
                                      color: isThisCorrect
                                          ? Colors.white
                                          : isThisSelected
                                              ? Colors.white
                                              : AppTheme.textPrimary,
                                      fontWeight:
                                          (isThisCorrect || isThisSelected)
                                              ? FontWeight.w600
                                              : FontWeight.normal,
                                    ),
                                  ),
                                ),
                                if (trailingIcon != null)
                                  Icon(trailingIcon, color: iconC, size: 20),
                              ],
                            ),
                          );
                        }),
                        const SizedBox(height: 12),

                        // Explanation Card
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppTheme.primary.withValues(alpha: 0.05),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: AppTheme.primary.withValues(alpha: 0.15),
                              width: 1,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.info_outline_rounded,
                                    size: 16,
                                    color: AppTheme.primary.withValues(alpha: 0.8),
                                  ),
                                  const SizedBox(width: 8),
                                  const Text(
                                    'Explanation',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: AppTheme.primary,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                question.explanation,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      color: AppTheme.textSecondary,
                                      fontSize: 13,
                                      height: 1.4,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
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
