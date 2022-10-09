// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:math';

import 'package:betterchips/data/gallery_options.dart';
import 'package:betterchips/layout/adaptive.dart';
import 'package:betterchips/layout/image_placeholder.dart';
import 'package:betterchips/layout/letter_spacing.dart';
import 'package:betterchips/layout/text_scale.dart';
import 'package:betterchips/setup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'constants.dart';

FirebaseAuth auth = FirebaseAuth.instanceFor(app: Firebase.app());

const _horizontalPadding = 24.0;

double desktopLoginScreenMainAreaWidth({required BuildContext context}) {
  return min(
    360 * reducedTextScale(context),
    MediaQuery.of(context).size.width - 2 * _horizontalPadding,
  );
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() {
    return _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> {
  late TextEditingController idController;
  late TextEditingController nameController;

  @override
  void initState() {
    super.initState();
    idController = TextEditingController();
    nameController = TextEditingController();
  }

  Widget actionButtons() {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    bool isDesktop = isDisplayDesktop(context);
    EdgeInsets buttonTextPadding =
        isDesktop ? const EdgeInsets.symmetric(horizontal: 12, vertical: 8) : EdgeInsets.zero;
    return Padding(
      padding: isDesktop ? EdgeInsets.zero : const EdgeInsets.all(4),
      child: OverflowBar(
        spacing: isDesktop ? 0 : 8,
        alignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: TextButton(
              /**
               * Create Table
               */
              onPressed: () async {
                try {
                  //final userCredential =
                  await FirebaseAuth.instance.signInAnonymously();
                  debugPrint('Signed in with temporary account.');
                } on FirebaseAuthException catch (e) {
                  switch (e.code) {
                    case 'operation-not-allowed':
                      debugPrint("Anonymous auth hasn't been enabled for this project.");
                      break;
                    default:
                      debugPrint('Unknown error.');
                  }
                }
                final snapshot =
                    await FirebaseDatabase.instance.ref().child('/${idController.text}').get();
                if (snapshot.exists) {
                  await showDialog<AlertDialog>(
                    context: context,
                    builder: (context) => _buildExistingTableDialog(context),
                  );
                } else {
                  Map<String, dynamic> json = <String, dynamic>{'chips': 0, 'gameMaster': true};

                  await FirebaseDatabase.instance
                      .ref()
                      .child('/${idController.text}/players/${nameController.text}')
                      .set(json);
                  await Navigator.pushReplacementNamed(context, '/setup',
                      arguments: ScreenArguments(idController.text, nameController.text, 0, 0));
                }
              },
              child: Padding(
                padding: buttonTextPadding,
                child: Text(
                  'Create Table',
                  style: TextStyle(color: colorScheme.onPrimary),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: ElevatedButton(
              /**
               * Join Table
               */
              onPressed: () async {
                ///
                /// Check if table exists
                final tableSnapshot =
                    await FirebaseDatabase.instance.ref().child('/${idController.text}').get();
                if (tableSnapshot.exists) {
                  ///
                  /// Check if Player exists
                  final playerSnapshot = await FirebaseDatabase.instance
                      .ref()
                      .child('/${idController.text}/players/${nameController.text}')
                      .get();
                  if (playerSnapshot.exists) {
                    ///
                    ///Check if Setup has been completed
                    final settingsSnapshot = await FirebaseDatabase.instance
                        .ref()
                        .child('${idController.text}/setup')
                        .get();
                    Map<String, dynamic>? json = settingsSnapshot.value as Map<String, dynamic>?;
                    if ((json?['setupFinished'] as bool?) ?? false) {
                      bool cont = false;
                      await showDialog<bool>(
                        context: context,
                        builder: (context) => _buildExistingPlayerDialog(context),
                      ).then((value) {
                        cont = value ?? false;
                      });

                      if (cont) {
                        await Navigator.pushReplacementNamed(context, '/game',
                            arguments: ScreenArguments(idController.text, nameController.text));
                      }
                    } else {
                      await showDialog<AlertDialog>(
                          context: context,
                          builder: (context) => _buildUnfinishedSetupDialog(context));
                    }
                  }
                } else {
                  await showDialog<bool>(
                    context: context,
                    builder: (context) => _buildNullTableDialog(context),
                  );
                }
              },
              child: Padding(
                padding: buttonTextPadding,
                child: Text(
                  'Join Table',
                  style: TextStyle(letterSpacing: letterSpacingOrNone(largeLetterSpacing)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExistingTableDialog(BuildContext context) {
    return AlertDialog(
      title: const Text('Table already exists'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const <Widget>[
          Text(
              'This table ID is already in use. If you\'re trying to join it, please click "Join Table", otherwise change the ID to one that isn\'t already in use'),
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

  Widget _buildUnfinishedSetupDialog(BuildContext context) {
    return AlertDialog(
      title: const Text('Setup isn\'t complete!'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const <Widget>[
          Text(
              'This table is not ready yet. Please wait for your game leader to finish setup, then join the table.'),
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

  Widget _buildExistingPlayerDialog(BuildContext context) {
    bool isDesktop = isDisplayDesktop(context);
    EdgeInsets buttonTextPadding =
        isDesktop ? const EdgeInsets.symmetric(horizontal: 12, vertical: 8) : EdgeInsets.zero;
    return AlertDialog(
      title: const Text('Player already exists'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const <Widget>[
          Text(
              'This name is already in use. If you\'re trying to rejoin, click "Proceed", otherwise change the name to one that isn\'t already in use'),
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.pop(context, false);
          },
          child: const Text(
            'Cancel',
          ),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context, true);
          },
          child: Padding(
            padding: buttonTextPadding,
            child: Text(
              'Proceed',
              style: TextStyle(letterSpacing: letterSpacingOrNone(largeLetterSpacing)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNullTableDialog(BuildContext context) {
    return AlertDialog(
      title: const Text('Table doesn\'t exist!'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const <Widget>[
          Text(
              'This Table ID does not exist. If you\'re trying to create it, close this  dialog and click "Create Table", otherwise enter a valid Table ID.'),
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text(
            'Okay',
          ),
        ),
      ],
    );
  }

  Widget nameTextField() {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return TextField(
      controller: nameController,
      textInputAction: TextInputAction.next,
      cursorColor: colorScheme.onSurface,
      decoration: InputDecoration(
        labelText: 'Name',
        labelStyle: TextStyle(
          letterSpacing: letterSpacingOrNone(mediumLetterSpacing),
        ),
      ),
    );
  }

  Widget idTextField() {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return TextField(
      controller: idController,
      cursorColor: colorScheme.onSurface,
      decoration: InputDecoration(
        labelText: 'Table ID',
        labelStyle: TextStyle(
          letterSpacing: letterSpacingOrNone(mediumLetterSpacing),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ModelBinding(
      initialModel: GalleryOptions(
        themeMode: ThemeMode.system,
        textScaleFactor: systemTextScaleFactorOption,
        customTextDirection: CustomTextDirection.localeBased,
        locale: null,
        timeDilation: timeDilation,
        platform: defaultTargetPlatform,
        isTestMode: true,
      ),
      child: ApplyTextOptions(
        child: Scaffold(
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: _horizontalPadding,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const BetterchipsLogo(),
                  const SizedBox(height: 40),
                  nameTextField(),
                  const SizedBox(height: 12),
                  idTextField(),
                  actionButtons(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class BetterchipsLogo extends StatelessWidget {
  const BetterchipsLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: Column(
        children: [
          const FadeInImagePlaceholder(
            /// @TODO: Add a new image and replace the placeholder"!
            image: AssetImage('packages/shrine_images/diamond.png'),
            placeholder: SizedBox(
              width: 34,
              height: 34,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'BetterChips',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ],
      ),
    );
  }
}
