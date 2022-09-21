// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:math';

import 'package:betterchips/data/gallery_options.dart';
import 'package:betterchips/layout/adaptive.dart';
import 'package:betterchips/layout/image_placeholder.dart';
import 'package:betterchips/layout/letter_spacing.dart';
import 'package:betterchips/layout/text_scale.dart';
import 'package:betterchips/studies/shrine/theme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../../constants.dart';

const _horizontalPadding = 24.0;

double desktopLoginScreenMainAreaWidth({required BuildContext context}) {
  return min(
    360 * reducedTextScale(context),
    MediaQuery.of(context).size.width - 2 * _horizontalPadding,
  );
}

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = isDisplayDesktop(context);

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
                          children: const [
                            _ShrineLogo(),
                            SizedBox(height: 40),
                            _UsernameTextField(),
                            SizedBox(height: 16),
                            _PasswordTextField(),
                            SizedBox(height: 24),
                            _CancelAndNextButtons(),
                            SizedBox(height: 62),
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
                    children: const [
                      SizedBox(height: 80),
                      _ShrineLogo(),
                      SizedBox(height: 120),
                      _UsernameTextField(),
                      SizedBox(height: 12),
                      _PasswordTextField(),
                      _CancelAndNextButtons(),
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

class _UsernameTextField extends StatelessWidget {
  const _UsernameTextField();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return TextField(
      textInputAction: TextInputAction.next,
      restorationId: 'username_text_field',
      cursorColor: colorScheme.onSurface,
      decoration: InputDecoration(
        labelText: 'Name',
        labelStyle: TextStyle(
          letterSpacing: letterSpacingOrNone(mediumLetterSpacing),
        ),
      ),
    );
  }
}

class _PasswordTextField extends StatelessWidget {
  const _PasswordTextField();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return TextField(
      restorationId: 'password_text_field',
      cursorColor: colorScheme.onSurface,
      obscureText: true,
      decoration: InputDecoration(
        labelText: 'Table ID',
        labelStyle: TextStyle(
          letterSpacing: letterSpacingOrNone(mediumLetterSpacing),
        ),
      ),
    );
  }
}

class _CancelAndNextButtons extends StatelessWidget {
  const _CancelAndNextButtons();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final isDesktop = isDisplayDesktop(context);

    final buttonTextPadding =
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
              onPressed: () {
                // The login screen is immediately displayed on top of
                // the Shrine home screen using onGenerateRoute and so
                // rootNavigator must be set to true in order to get out
                // of Shrine completely.
                Navigator.of(context, rootNavigator: true).pop();
              },
              child: Padding(
                padding: buttonTextPadding,
                child: Text(
                  'Create Table',
                  style: TextStyle(color: colorScheme.onSurface),
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(4.0),
            child: ElevatedButton(
              onPressed: () {
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
}
