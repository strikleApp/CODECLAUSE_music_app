import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:melody/constants/app_theme.dart';
import 'package:melody/function/music_player_streams.dart';
import 'package:melody/function/provider_function.dart';
import 'package:melody/screens/loading_screen.dart';
import 'package:melody/versionInfo/currentVersion.dart';
import 'package:melody/versionInfo/database.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:unity_ads_plugin/unity_ads_plugin.dart';

Future<void> _messageHandler(RemoteMessage message) async {
  print('background message ${message.notification!.body}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.strikle.melody',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
  );

  FirebaseMessaging.onBackgroundMessage(_messageHandler);
  UnityAds.init(gameId: '4379525', testMode: true);
  runApp(const MusicApp());
}

class MusicApp extends StatelessWidget {
  const MusicApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ProviderFunction>(
          create: (context) => ProviderFunction(),
        ),
        ChangeNotifierProvider<MusicPlayerStreams>(
          create: (context) => MusicPlayerStreams(),
        ),
        StreamProvider<VersionInfo>.value(
          value: Database().streamVersionInfo(),
          initialData: VersionInfo(versionNumber: currentVersion),
        )
      ],
      child: MaterialWidget(),
    );
  }
}

class MaterialWidget extends StatelessWidget {
  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  MaterialWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(builder: (context, orientation, screenType) {
      return MaterialApp(
        navigatorObservers: [
          FirebaseAnalyticsObserver(analytics: analytics),
        ],
        debugShowCheckedModeBanner: false,
        theme: appTheme,
        home: const LoadingScreen(),
      );
    });
  }
}
