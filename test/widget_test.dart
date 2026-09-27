import 'package:flutter_test/flutter_test.dart';
import 'package:smart_career/main.dart';

void main() {
  testWidgets('Smart Career App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const SmartCareerApp());
    expect(find.text("Yo'nalish"), findsWidgets);

    // Advance timer past splash duration
    await tester.pump(const Duration(seconds: 4));
  });
}
