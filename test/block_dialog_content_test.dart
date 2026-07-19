import 'package:block_dialog/block_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class _StretchHarness extends StatefulWidget {
  const _StretchHarness();

  @override
  State<_StretchHarness> createState() => _StretchHarnessState();
}

class _StretchHarnessState extends State<_StretchHarness>
    with SingleTickerProviderStateMixin {
  late final BlockDialogController controller;
  late final List<BlockRow> rows;

  @override
  void initState() {
    super.initState();
    rows = [
      BlockRow(
        blocks: [
          BlockCustom(
            minHeight: 40,
            builder: (_, __, ___, ____) {
              return const SizedBox(
                key: Key('tall-block'),
                height: 120,
              );
            },
          ),
          BlockCustom(
            minHeight: 40,
            builder: (_, __, ___, ____) {
              return const Align(
                key: Key('short-block'),
                alignment: Alignment.center,
                child: SizedBox(
                  width: 20,
                  height: 20,
                ),
              );
            },
          ),
        ],
      ),
    ];
    controller = BlockDialogController();
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
        body: Center(
          child: SizedBox(
            width: 320,
            child: BlockDialog.buildContent(
              rows: rows,
              controller: controller,
            ),
          ),
        ),
      ),
    );
  }
}

void main() {
  testWidgets(
    'BlockDialogContent stretches shorter blocks to match the tallest block',
    (tester) async {
      await tester.pumpWidget(const _StretchHarness());
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);

      final tallHeight =
          tester.getSize(find.byKey(const Key('tall-block'))).height;
      final shortHeight =
          tester.getSize(find.byKey(const Key('short-block'))).height;

      expect(tallHeight, 120);
      expect(shortHeight, tallHeight);
    },
  );
}
