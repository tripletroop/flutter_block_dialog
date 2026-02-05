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

  void _showCustomBlockDialog(BuildContext context) {
    BlockDialog.show<void>(
      context,
      configs: DialogConfig(blockAnimation: BlockAnimation.slide()),
      rows: [
        BlockRow(
          ignoreInPositionResolving: true,
          blocks: [
            BlockCustom(
              minHeight: 50,
              matchDialogTheme: false,
              override: BlockOverride(
                animationPosition: BlockPosition.top,
                customAnimation: BlockAnimation.slide(distanceMultiplier: 2),
              ),
              resultBuilder: () => {'custom_banner_shown': true},
              resultId: 'topBarBanner',
              builder: (context, controller, configs) => Container(
                height: 50,
                color: Colors.blue[50],
                child: Center(
                  child: Text(
                    'Banner Ad Placeholder',
                    style: TextStyle(color: Colors.blue[900]),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ],
        ),
        BlockRow(
          blocks: [
            BlockText(
              text: 'User Form',
              minHeight: 50,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ],
        ),
        BlockRow(
          blocks: [
            BlockInputField(
              resultId: 'name',
              override: BlockOverride(
                animationPosition: BlockPosition.middleRight,
              ),
              hintText: 'Enter your name',
            ),
          ],
        ),
        BlockRow(
          blocks: [
            BlockInputField(
              resultId: 'email',
              override: BlockOverride(
                animationPosition: BlockPosition.middleLeft,
              ),
              keyboardType: TextInputType.emailAddress,
              hintText: 'Enter your email',
            ),
          ],
        ),
        BlockRow(
          blocks: [
            BlockRadioGroup<String>(
              options: ['Male', 'Female'],
              resultId: 'gender',
            ),
          ],
        ),
        BlockRow(
          blocks: [
            BlockCheckbox(
              resultId: 'subscribe',
              initialValue: false,
              label: 'Subscribe to newsletter',
              override: BlockOverride(animationPosition: BlockPosition.middle),
            ),
          ],
        ),
        BlockRow(
          blocks: [
            BlockText(
              text: 'Left',
              minHeight: 50,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            BlockText(
              text: 'Middle',
              minHeight: 50,
              flex: 2,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            BlockText(
              text: 'Right',
              minHeight: 50,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
        BlockRow(
          blocks: [
            BlockButton(
              label: 'Submit',
              onValidate: (result) {
                final name = result.values['name'] as String?;
                if (name == null || name.isEmpty) {
                  return 'Name cannot be empty.';
                }
                final email = result.values['email'] as String?;
                if (email == null || !email.contains('@')) {
                  return 'Please enter a valid email address.';
                }
                return null;
              },
              onPressed: (result) async {
                await Future.delayed(
                  const Duration(milliseconds: 1000),
                ); // Simulate a network call
                final name = result.values['name'];
                final email = result.values['email'];
                final subscribe = result.values['subscribe'];
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Name=$name\nEmail=$email\nSubscribe=$subscribe',
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Block Dialog Example')),
      body: SafeArea(
        child: Container(
          child: Column(
            children: [
              Spacer(),
              Center(
                child: ElevatedButton(
                  child: const Text('Show Dialog'),
                  onPressed: () => _showCustomBlockDialog(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
