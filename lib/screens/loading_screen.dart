import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:melody/constants/constants.dart';
import 'package:melody/db/hive.dart';
import 'package:melody/function/audio_functions.dart';
import 'package:melody/function/provider_function.dart';
import 'package:melody/screens/main_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  static late SharedPreferences preferences;

  @override
  LoadingScreenState createState() => LoadingScreenState();
}

class LoadingScreenState extends State<LoadingScreen> {
  late Future getFuture;
  late FirebaseMessaging messaging;

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
      await HiveDB.initHive();
      if (mounted) {
        await Provider.of<ProviderFunction>(context, listen: false)
            .getVideosFromYoutube(kInitialSearchKeyword);
      }
      if (mounted) {
        await Provider.of<ProviderFunction>(context, listen: false)
            .getAllDownloads();
        if (mounted) {
          await AudioFunctions().getDownloadedAudio(context: context);
          mounted
              ? await Provider.of<ProviderFunction>(context, listen: false)
                  .getAllVideos()
              : null;
        }
      }
    } catch (e) {
      Future.error(e);
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
        if (!snapshot.hasError) {
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
