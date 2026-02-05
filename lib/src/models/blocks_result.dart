enum DismissReason {
  /// Dismissed by a block button.
  button,

  /// Dismissed by tapping outside or back.
  canceled,

  /// Dismissed programmatically by code.
  programmatic,
}

class BlocksResult<T> {
  /// Result returned from a dialog interaction.
  const BlocksResult({
    required this.dismissReason,
    required this.values,
    this.payload,
  });

  /// Why the dialog was dismissed.
  final DismissReason dismissReason;

  /// Map of block results keyed by [Block.resultId].
  final Map<String, dynamic> values;

  /// Optional payload (commonly set by buttons).
  final T? payload;

  /// Typed getter for a value stored under [resultKey].
  V get<V>({required String resultKey}) {
    final value = values[resultKey];
    assert(
      value is V,
      'BlocksResult: value for "$resultKey" is not of type $V '
      '(actual: ${value.runtimeType})',
    );
    return value as V;
  }

  bool get dismissedByButton => dismissReason == DismissReason.button;
  bool get dismissedByCancel => dismissReason == DismissReason.canceled;
  bool get dismissedByCode => dismissReason == DismissReason.programmatic;
}
