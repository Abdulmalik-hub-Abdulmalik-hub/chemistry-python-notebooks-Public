import 'package:flutter_test/flutter_test.dart';
import 'package:innovachem_labsuite/main.dart';

void main() {
  testWidgets('App launches successfully', (WidgetTester tester) async {
    await tester.pumpWidget(const InnovaChemLabSuiteApp());
    expect(find.text('InnovaChem LabSuite'), findsOneWidget);
  });
}
