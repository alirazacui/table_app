import 'package:flutter_test/flutter_test.dart';
import 'package:table_app/main.dart';

void main() {
  testWidgets('Multiplication Table app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const MultiplicationTableApp());
    expect(find.text('Multiplication Table'), findsOneWidget);
  });
}