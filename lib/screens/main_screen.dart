import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:melody/constants/constants.dart';
import 'package:melody/function/audio_functions.dart';
import 'package:melody/function/provider_function.dart';
import 'package:melody/screens/download_screen.dart';
import 'package:melody/screens/music_screen.dart';
import 'package:melody/screens/search_screen.dart';
import 'package:melody/screens/settings_screen.dart';
import 'package:melody/screens/video_screen.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  int _bottomBarIndex = 0;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _animationController = AnimationController(vsync: this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    setState(() {
      if (AppLifecycleState.detached == state) {
        AudioFunctions.player.stop();
        AudioFunctions.player.dispose();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
    AudioFunctions.player.stop();
    AudioFunctions.player.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: _buildCurvedNavigationBar(context),
      floatingActionButton: _bottomBarIndex == 0
          ? FloatingActionButton(
              child: const Icon(Icons.download_rounded),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const DownloadScreen()));
              })
          : null,
      body: IndexedStack(
        index: _bottomBarIndex,
        children: [
          const SearchScreen().animate(controller: _animationController).fade(),
          const MusicScreen().animate(controller: _animationController).fade(),
          const VideoScreen().animate(controller: _animationController).fade(),
          const SettingsScreen()
              .animate(controller: _animationController)
              .fade(),
        ],
      ),
    );
  }

  CurvedNavigationBar _buildCurvedNavigationBar(BuildContext context) {
    return CurvedNavigationBar(
      index: _bottomBarIndex,
      height: 6.5.h,
      color: Theme.of(context).colorScheme.primary,
      backgroundColor: Theme.of(context).colorScheme.onPrimary,
      buttonBackgroundColor: Theme.of(context).colorScheme.primary,
      onTap: (index) async {
        if (index != _bottomBarIndex) {
          setState(() {
            _bottomBarIndex = index;
            _animationController.reset();
            _animationController.forward();
          });
        } else if (_bottomBarIndex == 0 && index == 0) {
          await Provider.of<ProviderFunction>(context, listen: false)
              .getVideosFromYoutube(kInitialSearchKeyword);
        }
      },
      items: [
        Icon(
          Icons.search_rounded,
          color: Theme.of(context).colorScheme.onPrimary,
        ),
        Icon(
          Icons.audiotrack_rounded,
          color: Theme.of(context).colorScheme.onPrimary,
        ),
        Icon(
          Icons.ondemand_video,
          color: Theme.of(context).colorScheme.onPrimary,
        ),
        Icon(
          Icons.menu,
          color: Theme.of(context).colorScheme.onPrimary,
        ),
      ],
    );
  }
}
