import '../models/question.dart';

class QuizData {
  static const List<String> categories = [
    'Flutter & Dart',
    'Computer Science',
    'General Knowledge',
  ];

  static const Map<String, String> categoryDescriptions = {
    'Flutter & Dart':
        'Test your knowledge on widgets, state management, and Dart core features.',
    'Computer Science':
        'Data structures, algorithms, systems, and network fundamentals.',
    'General Knowledge':
        'Fun, interesting, and miscellaneous trivia from around the world.',
  };

  static const Map<String, String> categoryIcons = {
    'Flutter & Dart': 'code',
    'Computer Science': 'terminal',
    'General Knowledge': 'public',
  };

  static const List<Question> questions = [
    // --- FLUTTER & DART ---
    Question(
      id: 'fd1',
      category: 'Flutter & Dart',
      text:
          'What is the key difference between a StatelessWidget and a StatefulWidget?',
      options: [
        'StatelessWidgets cannot be animated, while Statefulness allows animations.',
        'StatelessWidget configuration is immutable, while StatefulWidget can maintain mutable state over time.',
        'StatelessWidgets are rendered on the GPU, while Statefulness renders on the CPU.',
        'StatefulWidgets use less memory and rebuild faster.',
      ],
      correctOptionIndex: 1,
      explanation:
          'StatelessWidgets are immutable. Their properties cannot change once built. StatefulWidgets maintain separate state objects that can persist and change across rebuilds using setState().',
    ),
    Question(
      id: 'fd2',
      category: 'Flutter & Dart',
      text:
          'Which function is called first in a StatefulWidget\'s State lifecycle?',
      options: [
        'build()',
        'didChangeDependencies()',
        'initState()',
        'didUpdateWidget()',
      ],
      correctOptionIndex: 2,
      explanation:
          'initState() is called exactly once when the State object is inserted into the tree. It is followed by didChangeDependencies() and then build().',
    ),
    Question(
      id: 'fd3',
      category: 'Flutter & Dart',
      text: 'What does the "const" constructor do in Dart?',
      options: [
        'It makes the variable private to the library.',
        'It tells the compiler to compile the code dynamically.',
        'It creates a canonical, compile-time constant instance, which reduces memory and helps optimize widget rebuilds.',
        'It prevents class inheritance.',
      ],
      correctOptionIndex: 2,
      explanation:
          'Using "const" constructors creates a single, immutable instance in memory that is shared at compile-time. If Flutter sees a const widget, it skips rebuilding it if parent rebuilds.',
    ),
    Question(
      id: 'fd4',
      category: 'Flutter & Dart',
      text:
          'Which operator is used to handle null values gracefully in Dart by providing a default value?',
      options: ['??', '?.', '!', '?'],
      correctOptionIndex: 0,
      explanation:
          'The ?? operator (null-coalescing operator) returns the left-hand expression if it is not null; otherwise, it evaluates and returns the right-hand expression.',
    ),
    Question(
      id: 'fd5',
      category: 'Flutter & Dart',
      text: 'What is the purpose of a BuildContext in Flutter?',
      options: [
        'It compiles the Dart code into machine code.',
        'It handles background file downloads.',
        'It is a handle to the location of a widget in the widget tree structure.',
        'It is used to manage database tables.',
      ],
      correctOptionIndex: 2,
      explanation:
          'BuildContext represents the location of a widget in the widget tree. It is used to look up parent widgets (like Themes or media queries) and pass data down the tree.',
    ),

    // --- COMPUTER SCIENCE ---
    Question(
      id: 'cs1',
      category: 'Computer Science',
      text:
          'What is the average time complexity of searching for an element in a balanced Binary Search Tree (BST)?',
      options: ['O(1)', 'O(N)', 'O(N log N)', 'O(log N)'],
      correctOptionIndex: 3,
      explanation:
          'A balanced BST halves the search space at each step, resulting in a logarithmic time complexity of O(log N).',
    ),
    Question(
      id: 'cs2',
      category: 'Computer Science',
      text:
          'Which of the following protocol operates at the Application Layer of the OSI model?',
      options: ['TCP', 'HTTP', 'IP', 'UDP'],
      correctOptionIndex: 1,
      explanation:
          'HTTP (Hypertext Transfer Protocol) is an Application layer protocol. TCP and UDP operate at the Transport layer, while IP operates at the Network layer.',
    ),
    Question(
      id: 'cs3',
      category: 'Computer Science',
      text:
          'In database systems, what does the "A" in ACID transactions stand for?',
      options: ['Availability', 'Atomicity', 'Association', 'Algorithm'],
      correctOptionIndex: 1,
      explanation:
          'ACID stands for Atomicity, Consistency, Isolation, and Durability. Atomicity ensures that all operations in a transaction either complete successfully or fail completely (all-or-nothing).',
    ),
    Question(
      id: 'cs4',
      category: 'Computer Science',
      text:
          'Which data structure follows the Last-In, First-Out (LIFO) principle?',
      options: ['Queue', 'Linked List', 'Stack', 'Heap'],
      correctOptionIndex: 2,
      explanation:
          'A Stack follows LIFO, where elements are inserted (push) and removed (pop) from the same end. A Queue follows FIFO (First-In, First-Out).',
    ),
    Question(
      id: 'cs5',
      category: 'Computer Science',
      text: 'What is the primary role of an Operating System Kernel?',
      options: [
        'To design the user interface components.',
        'To act as the bridge between software applications and the system hardware, managing memory, processes, and CPU time.',
        'To compile code to bytecode.',
        'To browse the internet securely.',
      ],
      correctOptionIndex: 1,
      explanation:
          'The kernel is the core of the operating system. It manages system resources, memory allocation, process schedules, and interfaces directly with hardware.',
    ),

    // --- GENERAL KNOWLEDGE ---
    Question(
      id: 'gk1',
      category: 'General Knowledge',
      text: 'Which planet in our solar system is known as the Red Planet?',
      options: ['Venus', 'Mars', 'Jupiter', 'Saturn'],
      correctOptionIndex: 1,
      explanation:
          'Mars is known as the Red Planet due to the iron oxide (rust) on its surface, which gives it a reddish appearance.',
    ),
    Question(
      id: 'gk2',
      category: 'General Knowledge',
      text: 'Who painted the famous artwork "The Starry Night"?',
      options: [
        'Leonardo da Vinci',
        'Pablo Picasso',
        'Vincent van Gogh',
        'Claude Monet',
      ],
      correctOptionIndex: 2,
      explanation:
          '"The Starry Night" was painted by the Dutch Post-Impressionist painter Vincent van Gogh in June 1889.',
    ),
    Question(
      id: 'gk3',
      category: 'General Knowledge',
      text: 'Which is the largest ocean on Earth?',
      options: [
        'Atlantic Ocean',
        'Indian Ocean',
        'Arctic Ocean',
        'Pacific Ocean',
      ],
      correctOptionIndex: 3,
      explanation:
          'The Pacific Ocean is the largest and deepest of Earth\'s oceanic divisions, covering about 46% of Earth\'s water surface.',
    ),
    Question(
      id: 'gk4',
      category: 'General Knowledge',
      text: 'How many bones are there in an adult human body?',
      options: ['106', '206', '306', '216'],
      correctOptionIndex: 1,
      explanation:
          'An adult human body typically has 206 bones, whereas infants are born with around 270 bones, some of which fuse together as they grow.',
    ),
    Question(
      id: 'gk5',
      category: 'General Knowledge',
      text: 'What is the capital of Japan?',
      options: ['Beijing', 'Seoul', 'Tokyo', 'Kyoto'],
      correctOptionIndex: 2,
      explanation: 'Tokyo is the capital and most populous city of Japan.',
    ),
  ];
}
