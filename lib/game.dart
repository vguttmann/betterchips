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

  @override
  void initState() {
    super.initState();
  }

  Query getPlayers() {
    final args = ModalRoute.of(context)!.settings.arguments as ScreenArguments;
    return FirebaseDatabase.instance.ref().child('/${args.gameID}/players');
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as ScreenArguments;
    currentMoney = args.currentMoney;
    minBet = args.minBet;

    return Scaffold(
      body: FirebaseAnimatedList(
        query: getPlayers(),
        itemBuilder: (context, snapshot, animation, index) {
          dynamic json = snapshot.value;
          return PlayerCard(json: json, name: snapshot.key ?? "Error");
        },
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
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
          const Divider(),
          0 == 0
              ? TextButton(onPressed: () {}, child: const Text('Fold'))
              : TextButton(onPressed: () {}, child: const Text('Bet'))
        ],
      ),
    );
    // return Scaffold(
    //   appBar: AppBar(
    //     /// disables the "back" button in the AppBar
    //     automaticallyImplyLeading: false,
    //     title: const Text('Second Screen'),
    //   ),
    //   body: Center(
    //     child: PlayerCard(
    //       isGameMaster: true,
    //       role: Role.bigBlind,
    //       name: args.name
    //     ),
    //   ),
    // );
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
        (await FirebaseDatabase.instance.ref().child('/${args.gameID}/setup/minBet').get())
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

  @override
  Widget build(BuildContext context) {
    bool isGameMaster = json['gameMaster'].toString().toLowerCase() == 'true';
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
                  BoxDecoration(color: Colors.purple, borderRadius: BorderRadius.circular(4.0)),
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                    ((Theme.of(context).textTheme.headline3?.fontSize ?? 8.0) / 4),
                    ((Theme.of(context).textTheme.headline3?.fontSize ?? 8.0) / 12),
                    ((Theme.of(context).textTheme.headline3?.fontSize ?? 8.0) / 4),
                    ((Theme.of(context).textTheme.headline3?.fontSize ?? 8.0) / 12)),
                child: Text(
                  'Role',
                  style: Theme.of(context).textTheme.headline5,
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
                  '2000',
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
