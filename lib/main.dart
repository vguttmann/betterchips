import 'package:betterchips/studies/shrine/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(

    MaterialApp(
      title: 'Named Routes Demo',

      // Define a dark, indigo and green theme
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.indigo)
            .copyWith(secondary: Colors.green, brightness: Brightness.dark),
      ),

      // Start the app with the "/" named route. In this case, the app starts
      // on the FirstScreen widget.
      initialRoute: '/  ',
      routes: {
        // When navigating to the "/" route, build the FirstScreen widget.
        '/': (context) => const LoginPage(),
        // When navigating to the "/login" route, build the FirstScreen widget.
        '/login': (context) => const LoginScreen(),
        // When navigating to the "/game" route, build the SecondScreen widget.
        '/game': (context) => const GameScreen(),
      },
    ),
  );
}



class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});


  @override
  Widget build(BuildContext context) {
    // TextEditingController idController = TextEditingController();
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          // Within the `FirstScreen` widget
          onPressed: () {
            // Navigate to the second screen using a named route.
            Navigator.pushReplacementNamed(context, '/game');
          },
          child: const Text('Launch screen'),
        ),
      ),
    );
  }
}

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        /// disables the "back" button in the AppBar
        //automaticallyImplyLeading: false,
        title: const Text('Second Screen'),
      ),
      body: const Center(
        child: Text('Game'),
      ),
    );
  }
}
