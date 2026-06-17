import 'package:flutter_test/flutter_test.dart';
import 'package:quiz_app/main.dart';

void main() {
  testWidgets('Quiz App initial category selection screen test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const QuizApp());

    // Verify that the title 'Quiz Quest' is shown
    expect(find.text('Quiz Quest'), findsOneWidget);
    
    // Verify that category screen header 'Choose a Category' is shown
    expect(find.text('Choose a Category'), findsOneWidget);

    // Verify that the three category names are rendered
    expect(find.text('Flutter & Dart'), findsOneWidget);
    expect(find.text('Computer Science'), findsOneWidget);
    expect(find.text('General Knowledge'), findsOneWidget);
  });
}
