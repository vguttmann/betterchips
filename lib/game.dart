import 'package:betterchips/setup.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

class Role {
  static const String player = 'player';
  static const String smallBlind = 'smallBlind';
  static const String bigBlind = 'bigBlind';
  static const String dealer = 'dealer';
}

class Status {
  static const String inGame = 'inGame';
  static const String folded = 'folded';
  static const String allIn = 'allIn';
  static const String out = 'out';
  static const String knock = 'knock';
}
// enum Status { inGame, folded, allIn, out }

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late int minBet;
  late int currentMoney;
  int currentRaise = 0;
  int currentBet = 0;
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

  Query getPot() {
    final args = ModalRoute.of(context)!.settings.arguments as ScreenArguments;
    return FirebaseDatabase.instance.ref().child('/${args.gameID}/data');
  }

  /// @TODO: Add rotating of roles!
  /// Triggered by GM in the setState of round completion

  /// @TODO: Add minimum player count check! (min 3 players)
  /// @TODO: Add the ability to remove players from the round!

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as ScreenArguments;
    currentMoney = args.currentMoney;
    minBet = args.minBet;

    Widget bottomNavigationBuilder(BuildContext context, AsyncSnapshot rootSnapshot) {
      Map<String, dynamic> players =
          (rootSnapshot.data['players'] as DataSnapshot).value as Map<String, dynamic>;
      Map<String, dynamic> data =
          (rootSnapshot.data['data'] as DataSnapshot).value as Map<String, dynamic>;
      List<Widget> getWidgets(BuildContext context, Map<String, dynamic> players) {
        List<Widget> widgets = [];

        widgets.add(const Divider());

        if (players[args.name]['role'] != Role.dealer) {
          /// @TODO: Add round controls here!
          widgets.add(Container());
        } else {
          /// Add bet control slider
          int minPlayerBet = 0;

          if (players[args.name]['role'] == Role.smallBlind && players[args.name]['bet'] == 0) {
            minPlayerBet = minBet;
          }

          if (players[args.name]['role'] == Role.bigBlind && players[args.name]['bet'] == 0) {
            minPlayerBet = minBet;
            if (data['bigBetsDouble'] as bool) {
              minPlayerBet += minBet;
            }
          }

          widgets.add(Slider(
            value: currentRaise.toDouble(),
            min: minPlayerBet.toDouble(),
            max: currentMoney.toDouble(),
            divisions: ((currentMoney - minPlayerBet) / minBet).round(),
            label: currentRaise.toString(),
            onChanged: (value) {
              setState(() {
                currentRaise = value.toInt();
              });
            },
          ));

          /// Add Divider to Buttons
          widgets.add(Divider(
            indent: (Theme.of(context).textTheme.headline3?.fontSize ?? 8.0) / 3,
            endIndent: (Theme.of(context).textTheme.headline3?.fontSize ?? 8.0) / 3,
          ));

          /// @TODO: This is horrible! PLEASE REWRITE!!!
          if (currentRaise != 0) {
            widgets.add(TextButton(onPressed: () {}, child: const Text('Bet')));
          } else if (players[args.name]['role'] != Role.smallBlind && currentBet == 0) {
            /// Set the bet for the smallBlind
            currentRaise = minBet;
            widgets.add(TextButton(onPressed: () {}, child: const Text('Bet')));
          } else if (players[args.name]['role'] != Role.bigBlind && currentBet == 0) {
            currentRaise = minBet;

            /// Set the bet for the bigBlind
            /// If the bigBlind is supposed to bet double, then do that!
            if (data['bigBetsDouble'] as bool) {
              currentRaise += minBet;
            }
            widgets.add(TextButton(onPressed: () {}, child: const Text('Bet')));
          } else {
            widgets.add(TextButton(
              child: const Text('Fold'),
              onPressed: () {
                setState(
                  () async {
                    await players[args.name].update({'status': Status.out});
                  },
                );
              },
            ));
          }
        }

        // [
        //
        //   /// @TODO: Add putting current bet here!
        //
        //   /// @TODO: Add match, fold, raise, reraise and knock buttons depending on context!
        //   /// @TODO: Lay out possible states, and implement that state machine here (DEA?)
        //
        //   /// @TODO: Style buttons and slider!
        //   /// @TODO: Add code to remove money from player and add to bet!
        //   /// @TODO: Add splitting the pot with all-in!
        //   ///
        //
        //   /// @TODO: add "all-in" code!
        //   /// Needs to keep in mind that all-in != all in for everyone always, but that it also
        //   /// always keeps up with everyone else!
        //
        //   ///currentCall StreamBuilder
        //
        // ],

        return widgets;
      }

      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: getWidgets(context, players),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo[900],
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Call: ',
                  style: Theme.of(context).textTheme.headline5,
                ),
                StreamBuilder(
                  stream: FirebaseDatabase.instance.ref('/${args.gameID}/data/call').onValue,
                  builder: (context, snapshot) {
                    dynamic call = (snapshot.data as DatabaseEvent).snapshot.value;
                    return Text(
                      call.toString(),
                      style: Theme.of(context).textTheme.headline5,
                    );
                  },
                ),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Pot: ',
                  style: Theme.of(context).textTheme.headline5,
                ),
                StreamBuilder(
                  stream: FirebaseDatabase.instance.ref('/${args.gameID}/data/pot').onValue,
                  builder: (context, snapshot) {
                    dynamic pot = (snapshot.data as DatabaseEvent).snapshot.value;
                    return Text(
                      pot.toString(),
                      style: Theme.of(context).textTheme.headline5,
                    );
                  },
                ),
              ],
            )
          ],
        ),
      ),
      body: FirebaseAnimatedList(
        query: getPlayers(),
        itemBuilder: (context, snapshot, animation, index) {
          dynamic json = snapshot.value;
          return PlayerCard(json: json, name: snapshot.key ?? 'Error');
        },
      ),
      // bottomNavigationBar: StreamBuilder(
      //     stream: FirebaseDatabase.instance.ref('/${args.gameID}/').onValue,
      //     builder: (context, snapshot) {
      //       return bottomNavigationBuilder(context, snapshot);
      //     }),
    );
  }

  Future<void> getCurrentMoney() async {
    final args = ModalRoute.of(context)!.settings.arguments as ScreenArguments;
    currentMoney = int.parse(
        (await FirebaseDatabase.instance.ref().child('/${args.gameID}//${args.name}/chips').get())
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
    switch(role){
      case Role.bigBlind:
        return 'Big Blind';
      case Role.smallBlind:
        return 'Small Blind';
      case Role.dealer:
        return 'Dealer';
      case Role.player:
        return 'Player';
      default:
    return 'Error';
    }
  }

  String getStatus(dynamic status) {
    switch(status){
      case Status.inGame:
        return 'In Game';
      case Status.allIn:
        return 'All In';
      case Status.folded:
        return 'Folded';
      case Status.out:
        return 'Out';
      case Status.knock:
        return 'Knocked';
      default:
        return 'Error';

    }
  }

  Color? getRoleColor(dynamic role) {
    switch(role){
      case Role.bigBlind:
        return Colors.orange;
      case Role.smallBlind:
        return Colors.purple;
      case Role.dealer:
        return Colors.grey[200];
      case Role.player:
        return Colors.indigo[900];
      default:
        return Colors.red[900];
    }
  }

  Color? getStatusColor(dynamic status) {
    switch(status){
      case Status.inGame:
        return Colors.green;
      case Status.allIn:
        return Colors.red;
      case Status.folded:
        return Colors.grey;
      case Status.out:
        return Colors.grey[900];
      case Status.knock:
        return Colors.greenAccent;
      default:
        return Colors.red[900];
    }
  }

  TextStyle? getPlayerTextStyle(dynamic role, BuildContext context) {
    switch(role){
      case Role.dealer:
        return Theme.of(context).textTheme.headline5?.copyWith(color: Colors.grey[900]);
      default:
        return Theme.of(context).textTheme.headline5;
    }
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
            /// NameRow
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// NameFlex
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

                /// GameMasterContainer
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

            /// RoleContainer
            Container(
              decoration: BoxDecoration(
                  color: getRoleColor(json['role']), borderRadius: BorderRadius.circular(4.0)),
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

            Padding(
                padding: EdgeInsets.all(
                    (Theme.of(context).textTheme.headline3?.fontSize ?? 8.0) / 5 * 2)),

            /// StatusContainer
            Container(
              decoration: BoxDecoration(
                  color: getStatusColor(json['status']), borderRadius: BorderRadius.circular(4.0)),
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                    ((Theme.of(context).textTheme.headline3?.fontSize ?? 8.0) / 4),
                    ((Theme.of(context).textTheme.headline3?.fontSize ?? 8.0) / 12),
                    ((Theme.of(context).textTheme.headline3?.fontSize ?? 8.0) / 4),
                    ((Theme.of(context).textTheme.headline3?.fontSize ?? 8.0) / 12)),
                child: Text(
                  getStatus(json['status']),
                  style: Theme.of(context).textTheme.headline5,
                ),
              ),
            ),
            Padding(
                padding:
                    EdgeInsets.all((Theme.of(context).textTheme.headline3?.fontSize ?? 8.0) / 4)),

            /// MoneyRow
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
