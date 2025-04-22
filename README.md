Multiplication Table is a Flutter-based educational app designed to help students learn and test their knowledge of multiplication tables. The app offers interactive learning, training, and testing features, with a focus on multiplication and division. It supports both mobile (Android/iOS) and web platforms, using shared_preferences for web-compatible storage.



Features





Learn Tables: View multiplication tables from 1 to 30 with detailed breakdowns.



Training Mode: Configure custom quizzes with selectable operations (+, -, *, /), number ranges, and question types (multiple choice, true/false, input).



Start Test: Take standardized tests and view statistics (accuracy, correct/wrong answers) from previous tests.



Settings: Adjust app settings (e.g., sound, dark mode).



Quiz System: Interactive quizzes with real-time feedback, counters for correct/wrong answers, and a result summary screen.



Web Compatibility: Runs on Edge/Chrome using shared_preferences for storage.



Project Structure

The project follows a modular structure for maintainability:

lib/
├── main.dart
├── models/
│   ├── question.dart
│   └── test_result.dart
├── screens/
│   ├── home_screen.dart
│   ├── learn_table/
│   │   ├── table_list_screen.dart
│   │   ├── table_detail_screen.dart
│   │   └── question_screen.dart
│   ├── training/
│   │   └── training_config_screen.dart
│   ├── start_test/
│   │   └── stats_screen.dart
│   ├── settings_screen.dart
│   └── result_summary_screen.dart
├── widgets/
│   ├── card_button.dart
│   ├── counter_display.dart
│   └── option_tile.dart
├── providers/
│   ├── quiz_provider.dart
│   └── settings_provider.dart
├── utils/
│   └── data_generator.dart
└── services/
    └── db_helper.dart





Models: Define data structures for questions and test results.



Screens: Contain UI logic for each app section.



Widgets: Reusable UI components.



Providers: Manage app state using the provider package.



Utils: Helper functions (e.g., question generation).



Services: Handle storage (shared_preferences for web, sqflite for mobile).



Installation

Prerequisites





Flutter SDK (version 3.6.2 or later)



Dart SDK (included with Flutter)



A code editor (e.g., VS Code)



(Optional) Android Studio for emulator testing

Steps





Clone the Repository:

git clone <repository_url>
cd table_app



Install Dependencies:

flutter pub get



Run the App:





Web:

flutter run -d edge --web-renderer html



Android Emulator:

flutter run -d emulator



Build for Production:





Web:

flutter build web



Android:

flutter build apk



Usage

Home Screen





Learn Table: Select a multiplication table (1-30) to view and start quizzes.



Training: Configure custom quizzes with operations, number ranges, and question types.



Start Test: Take standardized tests and view past results.



Settings: Adjust app preferences (e.g., sound, theme).

Quiz Features





Question Types: Multiple choice, true/false, and input-based questions.



Real-Time Feedback: Correct answers turn green, incorrect ones turn red, with counters for tracking progress.



Result Summary: View correct/wrong answers, accuracy, and detailed answer feedback.



Troubleshooting

Common Errors and Fixes





Shared Preferences Android Build Error:





Error: Could not create task ':shared_preferences_android:compileDebugUnitTestSources'.



Fix: Run flutter clean, flutter pub cache repair, and flutter pub get. If testing on web, use --web-renderer html.



Undefined Method QuestionScreen:





Error: Incorrect navigation syntax.



Fix: Ensure navigation uses Navigator.push with QuestionScreen as a widget (e.g., Navigator.push(context, MaterialPageRoute(builder: (context) => QuestionScreen(...)))).



Missing answer_tile.dart:





Error: uri_does_not_exist for ../widgets/answer_tile.dart.



Fix: Create lib/widgets/answer_tile.dart as provided.



Database Initialization Error (Web):





Error: Bad state: databaseFactory not initialized.



Fix: Use shared_preferences for web storage, as implemented in db_helper.dart.



Dead Code or Context Errors:





Error: dead_code or use_build_context_synchronously in question_screen.dart.



Fix: Simplify navigation logic and add mounted checks, as in the updated question_screen.dart.



Running on Third-Party Platforms

If you don’t have a physical device, you can test the app using:





Local Web Browser (Edge/Chrome): Run flutter run -d edge --web-renderer html.



CodeSandbox/StackBlitz: Upload your project to these online IDEs for browser-based testing.



BrowserStack/Sauce Labs: Use cloud-based emulators for simulated device testing (free trials available).



Local Android Emulator: Set up via Android Studio for mobile testing.



Contributing

Contributions are welcome! To contribute:





Fork the repository.



Create a feature branch (git checkout -b feature/new-feature).



Commit changes (git commit -m 'Add new feature').



Push to the branch (git push origin feature/new-feature).



Open a pull request.



License

This project is licensed under the MIT License. See the LICENSE file for details.



Acknowledgments





Built with Flutter.




![Screenshot_20250422-095224](https://github.com/user-attachments/assets/a20d2118-111b-4326-8439-fdc9731a056a)

![Screenshot_20250422-095228](https://github.com/user-attachments/assets/331cd1cc-57d5-4248-8050-6c402cee6d98)

![Screenshot_20250422-095233](https://github.com/user-attachments/assets/a7d5fdab-3d27-4ebe-801b-23098b8bbb70)

![Screenshot_20250422-095233](https://github.com/user-attachments/assets/2600a622-4c46-4733-bd02-d63921c74bb7)![Screenshot_20250422-095238](https://github.com/user-attachments/assets/31d303dd-7e59-4404-b543-a52a7aad5856)![Screenshot_20250422-095253](https://github.com/user-attachments/assets/90fd9ca3-98b3-4092-85e4-b3af141f3db7)

![Screenshot_20250422-095307](https://github.com/user-attachments/assets/daa31333-d615-4b09-b3df-4da02ba0f35d)





Uses Provider for state management.



Storage handled by Shared Preferences for web compatibility.
