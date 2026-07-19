import 'package:block_dialog/block_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class _ThemeHarness extends StatefulWidget {
  const _ThemeHarness();

  @override
  State<_ThemeHarness> createState() => _ThemeHarnessState();
}

class _ThemeHarnessState extends State<_ThemeHarness>
    with SingleTickerProviderStateMixin {
  late final BlockDialogController controller;
  late final List<BlockRow> rows;
  late final AnimationController animationController;

  @override
  void initState() {
    super.initState();
    controller = BlockDialogController();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    rows = [
      BlockRow(
        blocks: [
          BlockText('Hello'),
        ],
      ),
      BlockRow(
        blocks: [
          BlockInputField(
            resultId: 'input',
            initialText: 'sample',
          ),
        ],
      ),
      BlockRow(
        blocks: [
          BlockCheckbox(
            resultId: 'check',
            label: 'Agree',
            initialValue: false,
          ),
        ],
      ),
      BlockRow(
        blocks: [
          BlockButton(
            label: 'Save',
            closeOnPress: false,
            onPressed: (result, controller) async {},
          ),
        ],
      ),
    ];
    controller.initialize(
      rows: rows,
      textDirection: TextDirection.ltr,
      animationController: animationController,
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
      theme: ThemeData.light().copyWith(
        colorScheme: ThemeData.light().colorScheme.copyWith(
              onSurface: const Color(0xFF123456),
            ),
      ),
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
  testWidgets('Block dialog blocks follow theme text color', (tester) async {
    await tester.pumpWidget(const _ThemeHarness());

    final expectedColor = const Color(0xFF123456);

    expect(
      tester.widget<Text>(find.text('Hello')).style?.color,
      expectedColor,
    );
    expect(
      tester.widget<Text>(find.text('Agree')).style?.color,
      expectedColor,
    );
    expect(
      tester.widget<Text>(find.text('Save')).style?.color,
      expectedColor,
    );
    expect(
      tester.widget<TextField>(find.byType(TextField)).style?.color,
      expectedColor,
    );
  });
}
