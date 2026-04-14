import 'package:block_dialog/block_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class _ShakeBlock extends Block {
  _ShakeBlock() : super(flex: 1);

  @override
  Widget buildContent(
    BuildContext context,
    BlockDialogController controller,
    DialogConfig configs,
  ) {
    return const SizedBox(height: 50);
  }
}

class _ShakeHost extends StatelessWidget {
  const _ShakeHost({required this.block, required this.controller});

  final _ShakeBlock block;
  final BlockDialogController controller;

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) => KeyedSubtree(
        key: const ValueKey<String>('shake-host'),
        child: block.build(context, controller, const DialogConfig()),
      ),
    );
  }
}

double _currentShakeOffsetX(WidgetTester tester) {
  final transformFinder = find.descendant(
    of: find.byKey(const ValueKey<String>('shake-host')),
    matching: find.byType(Transform),
  );
  final transform = tester.widget<Transform>(transformFinder.first);
  return transform.transform.getTranslation().x;
}

void main() {
  testWidgets('Block.shake animates left/right then settles', (tester) async {
    final block = _ShakeBlock();
    final controller = BlockDialogController();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: _ShakeHost(block: block, controller: controller),
        ),
      ),
    );

    // The block should be stationary before shake is requested.
    expect(
      find.descendant(
        of: find.byKey(const ValueKey<String>('shake-host')),
        matching: find.byType(Transform),
      ),
      findsNothing,
    );

    block.shake();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 75));

    expect(
      find.descendant(
        of: find.byKey(const ValueKey<String>('shake-host')),
        matching: find.byType(Transform),
      ),
      findsOneWidget,
    );
    expect(_currentShakeOffsetX(tester).abs(), greaterThan(0.1));

    await tester.pump(const Duration(milliseconds: 350));

    expect(_currentShakeOffsetX(tester), closeTo(0, 0.1));
  });
}
