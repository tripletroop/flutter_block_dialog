import 'package:block_dialog/block_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class _RadioHarness<T> extends StatefulWidget {
  const _RadioHarness({
    required this.options,
    required this.onChanged,
    this.itemBuilderWithRadio,
  });

  final List<T> options;
  final ValueChanged<T?> onChanged;
  final Widget Function(
    BuildContext context,
    T option,
    bool selected,
    Widget radio,
    VoidCallback onSelect,
  )? itemBuilderWithRadio;

  @override
  State<_RadioHarness<T>> createState() => _RadioHarnessState<T>();
}

class _RadioHarnessState<T> extends State<_RadioHarness<T>>
    with SingleTickerProviderStateMixin {
  late final BlockDialogController controller;
  late final List<BlockRow> rows;

  @override
  void initState() {
    super.initState();
    final radio = BlockRadioGroup<T>(
      resultId: 'choice',
      options: widget.options,
      onChanged: widget.onChanged,
    );
    rows = [
      BlockRow(blocks: [radio]),
    ];
    controller = BlockDialogController();
    controller.initialize(
      rows: rows,
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
        body: BlockDialog.buildContent(rows: rows, controller: controller),
      ),
    );
  }
}

void main() {
  testWidgets('BlockRadioGroup reports selection changes', (tester) async {
    String? selected;
    await tester.pumpWidget(
      _RadioHarness<String>(
        options: const ['A', 'B'],
        onChanged: (value) => selected = value,
      ),
    );

    await tester.tap(find.text('B'));
    await tester.pumpAndSettle();

    expect(selected, 'B');
  });

}
