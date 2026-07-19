import 'package:block_dialog/block_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class _TextUpdateHarness extends StatefulWidget {
  const _TextUpdateHarness();

  @override
  State<_TextUpdateHarness> createState() => _TextUpdateHarnessState();
}

class _TextUpdateHarnessState extends State<_TextUpdateHarness>
    with SingleTickerProviderStateMixin {
  late final BlockDialogController controller;
  late final List<BlockRow> rows;

  @override
  void initState() {
    super.initState();
    controller = BlockDialogController();
    rows = [
      BlockRow(
        blocks: [
          BlockText('Initial', blockTag: 'status_text'),
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
  testWidgets('BlockText can be updated after lookup by tag', (tester) async {
    await tester.pumpWidget(const _TextUpdateHarness());

    expect(find.text('Initial'), findsOneWidget);

    final state = tester.state<_TextUpdateHarnessState>(
      find.byType(_TextUpdateHarness),
    );
    final updated = state.controller.setBlockText('status_text', 'Updated');
    expect(updated, isTrue);
    await tester.pump();

    expect(find.text('Initial'), findsNothing);
    expect(find.text('Updated'), findsOneWidget);
  });
}
