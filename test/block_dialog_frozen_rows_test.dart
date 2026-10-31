import 'package:block_dialog/block_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class _FrozenRowsHarness extends StatefulWidget {
  const _FrozenRowsHarness({required this.rows});

  final List<BlockRow> rows;

  @override
  State<_FrozenRowsHarness> createState() => _FrozenRowsHarnessState();
}

class _FrozenRowsHarnessState extends State<_FrozenRowsHarness>
    with SingleTickerProviderStateMixin {
  late final BlockDialogController controller;

  @override
  void initState() {
    super.initState();
    controller = BlockDialogController();
    controller.initialize(
      rows: widget.rows,
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
              rows: widget.rows,
              controller: controller,
            ),
          ),
        ),
      ),
    );
  }
}

BlockRow _frozenRow(String key) {
  return BlockRow(
    freeze: true,
    blocks: [
      BlockCustom(
        builder: (_, __, ___, ____) => SizedBox(
          key: Key(key),
          height: 40,
        ),
      ),
    ],
  );
}

BlockRow _defaultTitleRow({bool? freeze}) {
  return BlockRow(
    freeze: freeze,
    blocks: [
      BlockText('Dialog Title', isDialogTitle: true),
    ],
  );
}

BlockRow _defaultButtonsRow({bool? freeze}) {
  return BlockRow(
    freeze: freeze,
    blocks: [
      BlockButton(label: 'Cancel'),
      BlockButton(label: 'Save'),
    ],
  );
}

BlockRow _scrollableRow(String key) {
  return BlockRow(
    blocks: [
      BlockCustom(
        builder: (_, __, ___, ____) => SizedBox(
          key: Key(key),
          height: 40,
        ),
      ),
    ],
  );
}

void main() {
  testWidgets(
    'frozen rows at start and end stay outside scrollable area',
    (tester) async {
      await tester.pumpWidget(
        _FrozenRowsHarness(
          rows: [
            _frozenRow('top-frozen'),
            _scrollableRow('middle-scrollable'),
            _frozenRow('bottom-frozen'),
          ],
        ),
      );

      final scrollViewFinder = find.byType(SingleChildScrollView);
      expect(scrollViewFinder, findsOneWidget);

      expect(
        find.descendant(
          of: scrollViewFinder,
          matching: find.byKey(const Key('top-frozen')),
        ),
        findsNothing,
      );
      expect(
        find.descendant(
          of: scrollViewFinder,
          matching: find.byKey(const Key('middle-scrollable')),
        ),
        findsOneWidget,
      );
      expect(
        find.descendant(
          of: scrollViewFinder,
          matching: find.byKey(const Key('bottom-frozen')),
        ),
        findsNothing,
      );
    },
  );

  testWidgets(
    'throws when a frozen row is placed in the middle',
    (tester) async {
      await tester.pumpWidget(
        _FrozenRowsHarness(
          rows: [
            _scrollableRow('first-scrollable'),
            _frozenRow('invalid-frozen-middle'),
            _scrollableRow('last-scrollable'),
          ],
        ),
      );

      final exception = tester.takeException();
      expect(exception, isA<FlutterError>());
    },
  );

  testWidgets(
    'applies default freeze for first title row and last button row',
    (tester) async {
      await tester.pumpWidget(
        _FrozenRowsHarness(
          rows: [
            _defaultTitleRow(),
            _scrollableRow('middle-scrollable-default'),
            _defaultButtonsRow(),
          ],
        ),
      );

      final scrollViewFinder = find.byType(SingleChildScrollView);
      expect(scrollViewFinder, findsOneWidget);

      expect(
        find.descendant(
          of: scrollViewFinder,
          matching: find.text('Dialog Title'),
        ),
        findsNothing,
      );
      expect(
        find.descendant(
          of: scrollViewFinder,
          matching: find.byKey(const Key('middle-scrollable-default')),
        ),
        findsOneWidget,
      );
      expect(
        find.descendant(
          of: scrollViewFinder,
          matching: find.text('Cancel'),
        ),
        findsNothing,
      );
      expect(
        find.descendant(
          of: scrollViewFinder,
          matching: find.text('Save'),
        ),
        findsNothing,
      );
    },
  );

  testWidgets(
    'freeze false disables default freeze behavior',
    (tester) async {
      await tester.pumpWidget(
        _FrozenRowsHarness(
          rows: [
            _defaultTitleRow(freeze: false),
            _scrollableRow('middle-scrollable-override'),
            _defaultButtonsRow(freeze: false),
          ],
        ),
      );

      final scrollViewFinder = find.byType(SingleChildScrollView);
      expect(scrollViewFinder, findsOneWidget);

      expect(
        find.descendant(
          of: scrollViewFinder,
          matching: find.text('Dialog Title'),
        ),
        findsOneWidget,
      );
      expect(
        find.descendant(
          of: scrollViewFinder,
          matching: find.byKey(const Key('middle-scrollable-override')),
        ),
        findsOneWidget,
      );
      expect(
        find.descendant(
          of: scrollViewFinder,
          matching: find.text('Cancel'),
        ),
        findsOneWidget,
      );
      expect(
        find.descendant(
          of: scrollViewFinder,
          matching: find.text('Save'),
        ),
        findsOneWidget,
      );
    },
  );
}
