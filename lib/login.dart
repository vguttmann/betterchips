// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

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

const defaultLetterSpacing = 0.03;
const mediumLetterSpacing = 0.04;
const largeLetterSpacing = 1.0;
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
                  Map<String, dynamic> innerJson = <String, dynamic>{
                    'chips': 0,
                    'gameMaster': true
                  };
                  Map<String, dynamic> json = <String, dynamic>{
                    nameController.text: innerJson
                  };

                  await FirebaseDatabase.instance
                      .ref()
                      .child('/${idController.text}')
                      .push()
                      .set(json);
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
              onPressed: () async {
                /// @TODO: Add check if table id exists, and push dialog if not!
                final snapshot =
                await FirebaseDatabase.instance.ref().child('/${idController.text}/players/${nameController.text}').get();
                if (snapshot.exists) {
                  bool cont = false;
                  await showDialog<bool>(
                    context: context,
                    builder: (context) => _buildExistingPlayerDialog(context),
                  ).then((value) {
                    cont = value ?? false;
                  });

                  if(cont){
                    /// @TODO: add code to push the current route onto the screen
                  } else {
                    /// @TODO: add code to do nothing
                  }
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
          Text('This table ID is already in use. If you\'re trying to join it, please click "Join Table", otherwise change the ID to one that isn\'t already in use'),
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
          Text('This name is already in use. If you\'re trying to rejoin, click "Proceed", otherwise change the name to one that isn\'t already in use'),
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
              'Join Table',
              style: TextStyle(letterSpacing: letterSpacingOrNone(largeLetterSpacing)),
            ),
          ),
        ),      ],
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
    bool isDesktop = isDisplayDesktop(context);
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
        child: isDesktop
            ? LayoutBuilder(
                builder: (context, constraints) => Scaffold(
                  body: SafeArea(
                    child: Center(
                      child: SizedBox(
                        width: desktopLoginScreenMainAreaWidth(context: context),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const _ShrineLogo(),
                            const SizedBox(height: 40),
                            nameTextField(),
                            const SizedBox(height: 16),
                            idTextField(),
                            const SizedBox(height: 24),
                            actionButtons(),
                            const SizedBox(height: 62),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              )
            : Scaffold(
                body: SafeArea(
                  child: ListView(
                    restorationId: 'login_list_view',
                    physics: const ClampingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(
                      horizontal: _horizontalPadding,
                    ),
                    children: [
                      const SizedBox(height: 80),
                      const _ShrineLogo(),
                      const SizedBox(height: 120),
                      nameTextField(),
                      const SizedBox(height: 12),
                      idTextField(),
                      actionButtons(),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}

class _ShrineLogo extends StatelessWidget {
  const _ShrineLogo();

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
