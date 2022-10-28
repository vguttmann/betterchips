import 'package:betterchips/setup.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

enum Role { player, smallBlind, bigBlind, dealer }

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late int minBet;
  late int currentMoney;
  double currentBet = 0;
  int call = 0;
  int pot = 0;

  @override
  void initState() {
    super.initState();
  }

  Query getPlayers() {
    final args = ModalRoute.of(context)!.settings.arguments as ScreenArguments;
    return FirebaseDatabase.instance.ref().child('/${args.gameID}/players');
  }

  /// @TODO: Add rotating of roles!
  /// @TODO: Add inability of dealer to do stuff!
  /// @TODO: Add minimum player count check! (min 3 players)
  /// @TODO: Add the ability to remove players from the round!

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as ScreenArguments;
    currentMoney = args.currentMoney;
    minBet = args.minBet;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo[900],
        title: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Call: ',
                style: Theme.of(context).textTheme.headline5,
              ),
              Text(
                call.toString(),
                style: Theme.of(context).textTheme.headline5,
              )
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Pot: ',
                style: Theme.of(context).textTheme.headline5,
              ),
              Text(
                pot.toString(),
                style: Theme.of(context).textTheme.headline5,
              ),
            ],
          )
        ]),
      ),
      body: FirebaseAnimatedList(
        query: getPlayers(),
        itemBuilder: (context, snapshot, animation, index) {
          dynamic json = snapshot.value;
          return PlayerCard(json: json, name: snapshot.key ?? 'Error');
        },
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Divider(),
          Slider(
            value: currentBet,
            min: 0,
            max: currentMoney.toDouble(),
            divisions: (currentMoney / minBet).round(),
            label: currentBet.round().toString(),
            onChanged: (value) {
              setState(() {
                currentBet = value;
              });
            },
          ),
          Divider(
            indent: (Theme.of(context).textTheme.headline3?.fontSize ?? 8.0) / 3,
            endIndent: (Theme.of(context).textTheme.headline3?.fontSize ?? 8.0) / 3,
          ),

          /// @TODO: Add putting current bet here!
          /// @TODO: Add match, fold, raise, reraise and knock buttons depending on context!
          /// @TODO: Style buttons and slider!
          /// @TODO: Add code to remove money from player and add to bet!
          /// @TODO: Add splitting the pot with all-in!
          /// @TODO: add "all-in" code!

          currentBet == 0
              ? TextButton(onPressed: () {}, child: const Text('Fold'))
              : TextButton(onPressed: () {}, child: const Text('Bet'))
        ],
      ),
    );
  }

  Future<void> getCurrentMoney() async {
    final args = ModalRoute.of(context)!.settings.arguments as ScreenArguments;
    currentMoney = int.parse((await FirebaseDatabase.instance
            .ref()
            .child('/${args.gameID}/players/${args.name}/chips')
            .get())
        .value
        .toString());
  }

  Future<void> getMinBet() async {
    final args = ModalRoute.of(context)!.settings.arguments as ScreenArguments;

    minBet = int.parse(
        (await FirebaseDatabase.instance.ref().child('/${args.gameID}/data/minBet').get())
            .value
            .toString());
  }
}

class PlayerCard extends StatelessWidget {

  const PlayerCard({super.key, required this.json, required this.name});

  final dynamic json;
  final String name;

  TextStyle injectBackgroundColor(Color color, TextStyle textStyle) {
    return textStyle.copyWith(color: color);
  }

  String getRole(dynamic role) {
    if (role == 'smallBlind') {
      return 'Small Blind';
    }
    else if (role == 'bigBlind') {
      return 'Big Blind';
    } else if (role == 'dealer') {
      return 'Dealer';
    }
    return 'Player';
  }
  Color? getColor(dynamic role){
    if(role == 'bigBlind'){
      return Colors.orange;
    } else if(role == 'smallBlind'){
      return Colors.purple;
    } else if(role == 'dealer'){
      return Colors.grey[200];
    }
    return Colors.indigo[900];
  }

  TextStyle? getPlayerTextStyle(dynamic role, BuildContext context){
    if(role == 'dealer'){
      return Theme.of(context).textTheme.headline5?.copyWith(color: Colors.grey[900]);
    }
    return Theme.of(context).textTheme.headline5;
  }

  @override
  Widget build(BuildContext context) {
    bool isGameMaster = json['gameMaster'].toString().toLowerCase() == 'true';
    String role = getRole(json['role']);
    return Container(
      padding: EdgeInsets.all((Theme.of(context).textTheme.headline3?.fontSize ?? 8.0) / 4),
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                        ((Theme.of(context).textTheme.headline3?.fontSize ?? 8.0) / 2),
                        ((Theme.of(context).textTheme.headline3?.fontSize ?? 8.0) / 4),
                        ((Theme.of(context).textTheme.headline3?.fontSize ?? 8.0) / 2),
                        ((Theme.of(context).textTheme.headline3?.fontSize ?? 8.0) / 6)),
                    child: Text(
                      name,
                      style: Theme.of(context).textTheme.headline4,
                    ),
                  ),
                ),
                Container(
                  decoration: isGameMaster
                      ? BoxDecoration(
                          color: Colors.blueAccent, borderRadius: BorderRadius.circular(4.0))
                      : const BoxDecoration(),
                  child: Padding(
                    padding: EdgeInsets.all(
                        (Theme.of(context).textTheme.headline3?.fontSize ?? 8.0) / 6),
                    child: Text(
                      (isGameMaster ? 'GM' : ''),
                      style: Theme.of(context).textTheme.headline4,
                    ),
                  ),
                )
              ],
            ),
            Padding(
                padding:
                    EdgeInsets.all((Theme.of(context).textTheme.headline3?.fontSize ?? 8.0) / 5)),
            Container(
              decoration:
                  BoxDecoration(color: getColor(json['role']), borderRadius: BorderRadius.circular(4.0)),
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                    ((Theme.of(context).textTheme.headline3?.fontSize ?? 8.0) / 4),
                    ((Theme.of(context).textTheme.headline3?.fontSize ?? 8.0) / 12),
                    ((Theme.of(context).textTheme.headline3?.fontSize ?? 8.0) / 4),
                    ((Theme.of(context).textTheme.headline3?.fontSize ?? 8.0) / 12)),
                child: Text(
                  // role,
                  role,
                  style: getPlayerTextStyle(json['role'], context),
                ),
              ),
            ),

            /// Role
            Padding(
                padding: EdgeInsets.all(
                    (Theme.of(context).textTheme.headline3?.fontSize ?? 8.0) / 5 * 2)),

            Container(
              decoration:
                  BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(4.0)),
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                    ((Theme.of(context).textTheme.headline3?.fontSize ?? 8.0) / 4),
                    ((Theme.of(context).textTheme.headline3?.fontSize ?? 8.0) / 12),
                    ((Theme.of(context).textTheme.headline3?.fontSize ?? 8.0) / 4),
                    ((Theme.of(context).textTheme.headline3?.fontSize ?? 8.0) / 12)),
                child: Text(
                  'Status',
                  style: Theme.of(context).textTheme.headline5,
                ),
              ),
            ),
            Padding(
                padding:
                    EdgeInsets.all((Theme.of(context).textTheme.headline3?.fontSize ?? 8.0) / 4)),
            Row(
              children: [
                const Spacer(flex: 1),
                Text(
                  'Chips: ',
                  style: Theme.of(context).textTheme.headline5,
                ),
                Text(
                  json['chips'].toString(),
                  style: Theme.of(context).textTheme.headline5,
                ),
                const Spacer(flex: 2),
                Text(
                  'Bet: ',
                  style: Theme.of(context).textTheme.headline5,
                ),
                Text(
                  json['bet'].toString(),
                  style: Theme.of(context).textTheme.headline5,
                ),
                const Spacer(flex: 1),
              ],
            ),
            Padding(
                padding:
                    EdgeInsets.all((Theme.of(context).textTheme.headline3?.fontSize ?? 8.0) / 6)),
          ],
        ),
      ),
    );
  }
}
