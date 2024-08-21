import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:melody/constants/shared_preferences_keys.dart';
import 'package:melody/db/hive.dart';
import 'package:melody/function/provider_function.dart';
import 'package:melody/screens/main_screen.dart';
import 'package:melody/screens/ttsScreen.dart';
import 'package:provider/provider.dart';
import 'package:restart_app/restart_app.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  static late SharedPreferences preferences;

  @override
  LoadingScreenState createState() => LoadingScreenState();
}

class LoadingScreenState extends State<LoadingScreen> {
  late bool storagePermission = true;
  late Future getFuture;
  late FirebaseMessaging messaging;
  late bool isFirstTime = true;

  Future<void> firebaseFunction() async {
    messaging = FirebaseMessaging.instance;
    messaging.getToken().then(
          (value) {},
        );
    FirebaseMessaging.onMessage.listen(
      (RemoteMessage event) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text(event.notification!.title.toString()),
              content: Text(event.notification!.body.toString()),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('OK'))
              ],
            );
          },
        );
      },
    );
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print('Message clicked!');
    });
  }

  Future<void> initial() async {
    try {
      LoadingScreen.preferences = await SharedPreferences.getInstance();
      isFirstTime = LoadingScreen.preferences.getBool(spFirstTime) ?? true;
      await HiveDB.initHive();
      if (mounted) {
        await Provider.of<ProviderFunction>(context, listen: false)
            .getVideosFromYoutube();
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    getFuture = initial();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            backgroundColor: Theme.of(context).primaryColor,
            body: Center(
              child: SizedBox(
                width: 250.0,
                child: DefaultTextStyle(
                  style: const TextStyle(
                    fontSize: 80,
                    fontFamily: 'Damion',
                  ),
                  child: AnimatedTextKit(
                    repeatForever: true,
                    animatedTexts: [
                      FlickerAnimatedText('Melody'),
                    ],
                  ),
                ),
              ),
            ),
          );
        }
        if (!storagePermission) {
          return Scaffold(
            backgroundColor: Theme.of(context).colorScheme.onSecondary,
            body: Center(
              child: Container(
                padding: const EdgeInsets.all(16.0),
                margin: const EdgeInsets.symmetric(horizontal: 16.0),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.onPrimary,
                  borderRadius: BorderRadius.circular(16.0), // Rounded border
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10.0,
                      offset: const Offset(0, 5), // Shadow for some depth
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.storage_rounded,
                      color: Theme.of(context).primaryColor,
                      size: 100,
                    ),
                    const SizedBox(height: 16.0),
                    Text(
                      'Please grant storage permission.',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 16.0),
                    TextButton(
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                                top: Radius.circular(16.0)),
                          ),
                          builder: (context) {
                            return Container(
                              height: MediaQuery.of(context).size.height / 2.5,
                              padding: const EdgeInsets.all(16.0),
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(16.0)),
                              ),
                              child: Center(
                                child: Text(
                                  '1. Open your phone\'s settings.\n'
                                  '2. Open apps.\n'
                                  '3. Find this app from the list.\n'
                                  '4. Go to permissions.\n'
                                  '5. Grant storage permission.',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall
                                      ?.copyWith(color: Colors.white),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            );
                          },
                        );
                      },
                      child: Text(
                        'How can I do it?',
                        style: TextStyle(
                          fontSize: 20,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    TextButton(
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                                top: Radius.circular(16.0)),
                          ),
                          builder: (context) {
                            return Container(
                              height: MediaQuery.of(context).size.height / 2.5,
                              padding: const EdgeInsets.all(16.0),
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(16.0)),
                              ),
                              child: Center(
                                child: Text(
                                  'Storage permission is used here to download content and play them in respective players.',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall
                                      ?.copyWith(color: Colors.white),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            );
                          },
                        );
                      },
                      child: Text(
                        'Why permission is needed?',
                        style: TextStyle(
                          fontSize: 20,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    ElevatedButton(
                      onPressed: () {
                        Restart.restartApp();
                      },
                      child: const Text(
                        'I gave permission.',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
        if (isFirstTime && storagePermission) {
          return const TTSScreen();
        }
        if (storagePermission && !snapshot.hasError && !isFirstTime) {
          return const MainScreen();
        }
        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.onPrimary,
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error,
                color: Theme.of(context).primaryColor,
                size: 100,
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    'There was a error. This error is very unlikely. '
                    'Please email us about this at techaashish05@gmail.com\n '
                    'Please mention your android version and device name. \n'
                    'We will try to fix it ASAP.\n'
                    'You can try to fix it yourself, tap below to know how.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 25, color: Theme.of(context).primaryColor),
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return Container(
                        height: MediaQuery.of(context).size.height / 2.5,
                        color: Theme.of(context).primaryColor,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: Text(
                              '1. Check if you gave storage permission.\n'
                              '2. Check if your Device Storage or SD card contains Download folder.\n'
                              '3. Try to uninstall completely and reinstall.\n'
                              '4. Check your internet connectivity.\n'
                              '5. If nothing works then please let us know and '
                              'help us to improve.',
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
                child: const Text(
                  'What I can try?',
                  style: TextStyle(fontSize: 25),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
