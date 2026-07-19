import 'package:block_dialog/block_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class _ButtonUpdateHarness extends StatefulWidget {
  const _ButtonUpdateHarness();

  @override
  State<_ButtonUpdateHarness> createState() => _ButtonUpdateHarnessState();
}

class _ButtonUpdateHarnessState extends State<_ButtonUpdateHarness>
    with SingleTickerProviderStateMixin {
  late final BlockDialogController controller;
  late final List<BlockRow> rows;
  int taps = 0;

  @override
  void initState() {
    super.initState();
    controller = BlockDialogController();
    rows = [
      BlockRow(
        blocks: [
          BlockButton(
            label: 'Save',
            blockTag: 'action_btn',
            closeOnPress: false,
            onPressed: (_, __) {
              taps += 1;
            },
          ),
        ],
      ),
    ];

    controller.initialize(
      rows: rows,
      textDirection: TextDirection.ltr,
      animationController: AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 200),
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: BlockDialog.buildContent(
          rows: rows,
          controller: controller,
        ),
      ),
    );
  }
}

void main() {
  testWidgets('BlockButton label can be updated by tag', (tester) async {
    await tester.pumpWidget(const _ButtonUpdateHarness());

    expect(find.text('Save'), findsOneWidget);

    final state = tester.state<_ButtonUpdateHarnessState>(
      find.byType(_ButtonUpdateHarness),
    );

    final updated = state.controller.setBlockButtonLabel('action_btn', 'Send');
    expect(updated, isTrue);

    await tester.pump();

    expect(find.text('Save'), findsNothing);
    expect(find.text('Send'), findsOneWidget);
  });

  testWidgets('BlockButton enabled can be updated by tag', (tester) async {
    await tester.pumpWidget(const _ButtonUpdateHarness());

    final state = tester.state<_ButtonUpdateHarnessState>(
      find.byType(_ButtonUpdateHarness),
    );

    await tester.tap(find.text('Save'));
    await tester.pump();
    expect(state.taps, 1);

    final disabled =
        state.controller.setBlockButtonEnabled('action_btn', false);
    expect(disabled, isTrue);
    await tester.pump();

    await tester.tap(find.text('Save'));
    await tester.pump();
    expect(state.taps, 1);

    final enabled = state.controller.setBlockButtonEnabled('action_btn', true);
    expect(enabled, isTrue);
    await tester.pump();

    await tester.tap(find.text('Save'));
    await tester.pump();
    expect(state.taps, 2);
  });
}
