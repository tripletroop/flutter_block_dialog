import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:block_dialog_example/main.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('dialog flow collects values and closes', (tester) async {
    await tester.pumpWidget(const BlockDialogExampleApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Show Dialog'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).at(0), 'Sara');
    await tester.enterText(find.byType(TextField).at(1), 'sara@example.com');

    await tester.tap(find.text('Female'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Subscribe to newsletter'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Submit'));
    await tester.pumpAndSettle(const Duration(seconds: 2));

    expect(find.textContaining('Name='), findsOneWidget);
    expect(find.byType(Dialog), findsNothing);
  });
}
