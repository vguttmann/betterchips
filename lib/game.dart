import 'package:flutter/material.dart';
import 'dart:math';

import 'package:betterchips/data/gallery_options.dart';
import 'package:betterchips/layout/adaptive.dart';
import 'package:betterchips/layout/image_placeholder.dart';
import 'package:betterchips/layout/letter_spacing.dart';
import 'package:betterchips/layout/text_scale.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'constants.dart';

enum Role { player, smallBlind, bigBlind, dealer }

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        /// disables the "back" button in the AppBar
        automaticallyImplyLeading: false,
        title: const Text('Second Screen'),
      ),
      body: const Center(
        child: PlayerCard(
          isGameMaster: true,
          role: Role.bigBlind,
        ),
      ),
    );
  }
}

class PlayerCard extends StatelessWidget {
  const PlayerCard({Key? key, required this.role, required this.isGameMaster}) : super(key: key);

  final bool isGameMaster;
  final Role role;

  TextStyle injectBackgroundColor(Color color, TextStyle textStyle) {
    return textStyle.copyWith(color: color);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all((Theme.of(context).textTheme.headline3?.fontSize ?? 8.0) / 4),
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.orangeAccent, borderRadius: BorderRadius.circular(4.0)),
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(
                          ((Theme.of(context).textTheme.headline3?.fontSize ?? 8.0) / 2),
                          ((Theme.of(context).textTheme.headline3?.fontSize ?? 8.0) / 6),
                          ((Theme.of(context).textTheme.headline3?.fontSize ?? 8.0) / 2),
                          ((Theme.of(context).textTheme.headline3?.fontSize ?? 8.0) / 6)),
                      child: Text(
                        'Name',
                        style: Theme.of(context).textTheme.headline4,
                      ),
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
            Padding(padding: EdgeInsets.all((Theme.of(context).textTheme.headline3?.fontSize ?? 8.0) / 5)),
            Container(
              decoration: BoxDecoration(
                  color: Colors.purple, borderRadius: BorderRadius.circular(4.0)),
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
            ), /// Role
            Padding(padding: EdgeInsets.all((Theme.of(context).textTheme.headline3?.fontSize ?? 8.0) / 5 * 2)),

            Container(
              decoration: BoxDecoration(
                  color: Colors.red, borderRadius: BorderRadius.circular(4.0)),
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                    ((Theme.of(context).textTheme.headline3?.fontSize ?? 8.0) / 4),
                    ((Theme.of(context).textTheme.headline3?.fontSize ?? 8.0) / 12),
                    ((Theme.of(context).textTheme.headline3?.fontSize ?? 8.0) / 4),
                    ((Theme.of(context).textTheme.headline3?.fontSize ?? 8.0) / 12)),                child: Text(
                  'Status',
                  style: Theme.of(context).textTheme.headline5,
                ),
              ),
            ),
            Padding(padding: EdgeInsets.all((Theme.of(context).textTheme.headline3?.fontSize ?? 8.0) / 4)),
            Row(
              children: [
                const Spacer(flex: 1),
                Text(
                  'Chips: ',
                  style: Theme.of(context).textTheme.headline5,
                ),
                Text(
                  '2000',
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
            Padding(padding: EdgeInsets.all((Theme.of(context).textTheme.headline3?.fontSize ?? 8.0) / 6)),
          ],
        ),
      ),
    );
  }
}
