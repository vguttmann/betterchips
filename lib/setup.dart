import 'package:betterchips/layout/letter_spacing.dart';
import 'package:flutter/material.dart';

import 'constants.dart';

class SetupScreen extends StatefulWidget {
  const SetupScreen({super.key});

  @override
  State<SetupScreen> createState() => _SetupScreenState();
}

class _SetupScreenState extends State<SetupScreen> {
  bool bigBetsDouble = true;
  bool splitPot = true;
  late TextEditingController minBetController;
  late TextEditingController initialMoneyController;

  @override
  void initState() {
    super.initState();
    minBetController = TextEditingController(text: '25');
    initialMoneyController = TextEditingController(text: '1000');
  }

  Color getColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return Colors.red;
    }
    return Colors.green;
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      /// We don't need an AppBar where we're going
      // appBar: AppBar(
      //   /// disables the "back" button in the AppBar
      //   automaticallyImplyLeading: false,
      //   title: const Text('Second Screen'),
      // ),
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
                  return (value != null && value.contains('[^0-9]'))
                      ? 'Please input an integer'
                      : null;
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
                  return (value != null && value.contains('[^0-9]'))
                      ? 'Please input an integer'
                      : null;
                },
                decoration: InputDecoration(
                  labelText: 'Minimum Small Blind Bet',
                  labelStyle: TextStyle(
                    letterSpacing: letterSpacingOrNone(mediumLetterSpacing),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      'Big Blind bets double of Small Blind',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                  Checkbox(
                    fillColor: MaterialStateProperty.resolveWith(getColor),
                    checkColor: Colors.white,
                    value: bigBetsDouble,
                    onChanged: (value) {
                      setState(() {
                        bigBetsDouble = value!;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      'After an all-in round is complete, the pot is split',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                  Checkbox(
                    fillColor: MaterialStateProperty.resolveWith(getColor),
                    checkColor: Colors.white,
                    value: splitPot,
                    onChanged: (value) {
                      setState(() {
                        splitPot = value!;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            ///@TODO: Add push settings to Firebase RTDB here, and mark round as set up!
            Navigator.pushReplacementNamed(context, '/game');
          },
          child: const Icon(Icons.navigate_next)),
    );
  }
}
