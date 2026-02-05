import 'package:block_dialog/block_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class _TestApp extends StatelessWidget {
  const _TestApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: ElevatedButton(
            onPressed: () {
              BlockDialog.show<void>(
                context,
                rows: [
                  BlockRow(blocks: [
                    BlockText(text: 'Hello'),
                  ]),
                  BlockRow(blocks: [
                    BlockButton(label: 'Close', onPressed: (_) async {}),
                  ]),
                ],
              );
            },
            child: const Text('Open'),
          ),
        ),
      ),
    );
  }
}

void main() {
  testWidgets('BlockDialog shows and dismisses on barrier tap', (tester) async {
    await tester.pumpWidget(const _TestApp());

    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();

    expect(find.text('Hello'), findsOneWidget);

    await tester.tapAt(const Offset(10, 10));
    await tester.pumpAndSettle(const Duration(milliseconds: 600));

    expect(find.text('Hello'), findsNothing);
  });
}
