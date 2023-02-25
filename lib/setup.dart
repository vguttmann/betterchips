import 'package:betterchips/layout/letter_spacing.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'constants.dart';

class ScreenArguments {
  final String gameID;
  final String name;
  final int minBet;
  final int currentMoney;

  ScreenArguments(this.gameID, this.name, this.minBet, this.currentMoney);
}

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
    return Colors.indigo;
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    final args = ModalRoute.of(context)!.settings.arguments as ScreenArguments;

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
          onPressed: () async {
            if (int.parse(initialMoneyController.text) % int.parse(minBetController.text) == 0) {
              Map<String, dynamic> json = <String, dynamic>{
                'initialMoney': int.parse(initialMoneyController.text),
                'minBet': int.parse(minBetController.text),
                'bigBetsDouble': bigBetsDouble,
                'splitPot': splitPot,
                'setupFinished': true,
              };

              await FirebaseDatabase.instance.ref().child('/${args.gameID}/data/').set(json);
              await FirebaseDatabase.instance
                  .ref()
                  .child('${args.gameID}/players/${args.name}/')
                  .update({'chips': int.parse(initialMoneyController.text)});
              await Navigator.pushReplacementNamed(context, '/game',
                  arguments: ScreenArguments(args.gameID, args.name,
                      int.parse(minBetController.text), int.parse(initialMoneyController.text)));
            } else {
              await showDialog<AlertDialog>(
                context: context,
                builder: (context) => _buildNotDivisibleDialog(context),
              );
            }
          },
          child: const Icon(Icons.navigate_next)),
    );
  }

  Widget _buildNotDivisibleDialog(BuildContext context) {
    return AlertDialog(
      title: const Text('Initial chips not divisible by minimum bet!'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const <Widget>[
          Text(
              'The initial amount of money isn\'t divisible by the minimum Bet. Please change either value so they are wholly divisible.'),
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text(
            'Okay',
          ),
        ),
      ],
    );
  }
}
