import 'package:block_dialog/block_dialog.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('BlocksResult stores values and provides typed access', () {
    const result = BlocksResult<Map<String, dynamic>>(
      dismissReason: DismissReason.button,
      values: {'name': 'Ali', 'age': 30},
    );

    expect(result.dismissedByButton, isTrue);
    expect(result.dismissedByCancel, isFalse);
    expect(result.dismissedByCode, isFalse);

    expect(result.get<String>(resultKey: 'name'), 'Ali');
    expect(result.get<int>(resultKey: 'age'), 30);
  });

  test('BlocksResult throws on incorrect type', () {
    const result = BlocksResult<void>(
      dismissReason: DismissReason.programmatic,
      values: {'age': 30},
    );

    expect(
      () => result.get<String>(resultKey: 'age'),
      throwsA(isA<AssertionError>()),
    );
  });
}
