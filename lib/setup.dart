import 'package:betterchips/layout/letter_spacing.dart';
import 'package:flutter/material.dart';

import 'constants.dart';

class SetupScreen extends StatefulWidget {
  const SetupScreen({super.key});

  @override
  State<SetupScreen> createState() => _SetupScreenState();
}

class _SetupScreenState extends State<SetupScreen> {
  late TextEditingController minBetController;
  late TextEditingController initialMoneyController;

  @override
  void initState() {
    super.initState();
    minBetController = TextEditingController(text: '25');
    initialMoneyController = TextEditingController(text: '1000');
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        /// disables the "back" button in the AppBar
        automaticallyImplyLeading: false,
        title: const Text('Second Screen'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: initialMoneyController,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                cursorColor: colorScheme.onSurface,
                validator: (value) {
                  return (value != null && value.contains('[^0-9]')) ? 'Please input an integer' : null;
                },
                decoration: InputDecoration(
                  labelText: 'Initial amount of money',
                  labelStyle: TextStyle(
                    letterSpacing: letterSpacingOrNone(mediumLetterSpacing),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: minBetController,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                cursorColor: colorScheme.onSurface,
                validator: (value) {
                  return (value != null && value.contains('[^0-9]')) ? 'Please input an integer' : null;
                },
                decoration: InputDecoration(
                  labelText: 'Minimum Small Blind Bet',
                  labelStyle: TextStyle(
                    letterSpacing: letterSpacingOrNone(mediumLetterSpacing),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/game');
          },
          child: const Icon(Icons.navigate_next)),
    );
  }
}
