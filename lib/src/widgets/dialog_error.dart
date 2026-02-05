import 'package:flutter/material.dart';

class DialogError extends StatelessWidget {
  /// Error banner shown beneath the dialog when validation fails.
  final String errorMessage;

  /// Callback to clear the error.
  final VoidCallback? onClear;
  const DialogError(
      {super.key, required this.errorMessage, required this.onClear});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      margin: const EdgeInsets.only(top: 4),
      decoration: BoxDecoration(
          color: Colors.red.shade100, borderRadius: BorderRadius.circular(20)),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: Colors.red),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              errorMessage,
              style: const TextStyle(
                  color: Colors.red, fontWeight: FontWeight.bold),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, size: 18, color: Colors.red),
            onPressed: onClear,
          ),
        ],
      ),
    );
  }
}
