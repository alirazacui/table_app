class TestResult {
  final int id;
  final int completedTests;
  final double accuracy;
  final int correctAnswers;
  final int wrongAnswers;
  final String complexity;
  final DateTime timestamp;
  final List<Map<String, String>> answers; // Stores question, correct, user answers

  TestResult({
    this.id = 0,
    required this.completedTests,
    required this.accuracy,
    required this.correctAnswers,
    required this.wrongAnswers,
    required this.complexity,
    required this.timestamp,
    required this.answers,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'completedTests': completedTests,
      'accuracy': accuracy,
      'correctAnswers': correctAnswers,
      'wrongAnswers': wrongAnswers,
      'complexity': complexity,
      'timestamp': timestamp.toIso8601String(),
      'answers': answers.map((e) => '${e['question']}|${e['correct']}|${e['user']}').join(';'),
    };
  }

  static TestResult fromMap(Map<String, dynamic> map) {
    return TestResult(
      id: map['id'],
      completedTests: map['completedTests'],
      accuracy: map['accuracy'],
      correctAnswers: map['correctAnswers'],
      wrongAnswers: map['wrongAnswers'],
      complexity: map['complexity'],
      timestamp: DateTime.parse(map['timestamp']),
      answers: (map['answers'] as String).split(';').map((e) {
        final parts = e.split('|');
        return {
          'question': parts[0],
          'correct': parts[1],
          'user': parts[2],
        };
      }).toList(),
    );
  }
}