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

class GameScreen extends StatefulWidget {
  const GameScreen({Key? key}) : super(key: key);

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        /// disables the "back" button in the AppBar
        //automaticallyImplyLeading: false,
        title: const Text('Second Screen'),
      ),
      body: const Center(
        child: PlayerCard(),
      ),
    );
  }
}

class PlayerCard extends StatelessWidget {
  const PlayerCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400,
      height: 300,
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Name',
                    style: Theme.of(context).textTheme.headline4,
                  ),
                  Text(
                    'GM',
                    style: Theme.of(context).textTheme.headline4,
                  )
                ],
              ),
              const Spacer(flex: 1),
              Text(
                'Role',
                style: Theme.of(context).textTheme.headline5,
              ),
              const Spacer(
                flex: 4
              ),
              Text(
                'Status',
                style: Theme.of(context).textTheme.headline5,
              ),
              const Spacer(
                flex: 2
              ),
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
                  const Spacer(flex: 4),
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
