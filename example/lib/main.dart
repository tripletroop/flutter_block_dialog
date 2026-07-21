import 'package:block_dialog/block_dialog.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const BlockDialogExampleApp());
}

/// The main example application.
class BlockDialogExampleApp extends StatelessWidget {
  const BlockDialogExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Block Dialog Example',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: const ExampleHome(),
    );
  }
}

/// The home screen with example dialogs.
class ExampleHome extends StatelessWidget {
  const ExampleHome({super.key});

  // placeholder for a preloaded banner ad widget, which can be used in the dialog
  BlockRow adRow(BuildContext context) {
    return BlockRow(
      ignoreInPositionResolving: true,
      width: MediaQuery.of(context).size.width,
      blocks: [
        BlockCustom(
          matchDialogTheme: false,
          override: BlockOverride(
            animationPosition: BlockPosition.top,
            customAnimation: BlockAnimation.slide(distanceMultiplier: 2),
          ),
          builder: (context, dialogController, blockController, configs) =>
              Container(
                height: 50,
                color: Colors.blue[50],
                child: const Center(child: Text('Banner Ad Placeholder')),
              ),
        ),
      ],
    );
  }

  void showSimpleConfirmationDialog(BuildContext context) {
    BlockDialog.show(
      context,
      rows: [
        adRow(context),
        BlockRow(blocks: [BlockText('Confirmation', isDialogTitle: true)]),
        BlockRow(blocks: [BlockText('Are you sure?')]),
        BlockRow(
          blocks: [
            BlockButton(label: 'Cancel'),
            BlockButton(
              label: 'Confirm',
              isPositive: true,
              onPressed: (results, dialogController) =>
                  showResult(context, 'Confirmed!'),
            ),
          ],
        ),
      ],
    );
  }

  void showUseFormDialog(BuildContext context) {
    BlockDialog.show(
      context,
      rows: [
        adRow(context),
        BlockRow(blocks: [BlockText('User Form', isDialogTitle: true)]),
        BlockRow(
          blocks: [
            BlockInputField(
              blockTag: 'email',
              hintText: 'Please enter your Email',
            ),
          ],
        ),
        BlockRow(
          blocks: [
            BlockInputField(
              blockTag: 'password',
              hintText: 'Please enter your Password',
              obscureText: true,
            ),
          ],
        ),
        BlockRow(
          blocks: [
            BlockRadioGroup<String>(
              blockTag: 'switch',
              options: ['Log In', 'Sign Up'],
              initialValue: 'Log In',
              onChanged: (value, controller) {
                controller.setBlockButtonLabel('button', value);
              },
            ),
          ],
        ),
        BlockRow(
          blocks: [
            BlockButton(
              label: 'Log In',
              blockTag: 'button',
              isPositive: true,
              onPressedWithError: (results, dialogController) {
                final email = results.getValue(blockTag: 'email');
                final password = results.getValue(blockTag: 'password');
                if (email == null || email.isEmpty) {
                  dialogController.shakeBlock('email');
                  dialogController.setBlockInputFieldErrorText(
                    'email',
                    'Email is required',
                  );
                  return 'Email is required';
                }
                if (password == null || password.isEmpty) {
                  dialogController.shakeBlock('password');
                  dialogController.setBlockInputFieldErrorText(
                    'password',
                    'Password is required',
                  );
                  return 'Password is required';
                }
                if (password.length < 6) {
                  dialogController.shakeBlock('password');
                  dialogController.setBlockInputFieldErrorText(
                    'password',
                    'Password must be at least 6 characters',
                  );
                  return 'Password must be at least 6 characters';
                }
                showResult(context, 'Email: $email\nPassword: $password');
                return null;
              },
            ),
          ],
        ),
      ],
    );
  }

  void showResult(BuildContext context, String result) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Block Dialog Example')),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              child: const Text('Simple Confirmation Dialog'),
              onPressed: () => showSimpleConfirmationDialog(context),
            ),
            ElevatedButton(
              child: const Text('User Form Dialog'),
              onPressed: () => showUseFormDialog(context),
            ),
          ],
        ),
      ),
    );
  }
}
