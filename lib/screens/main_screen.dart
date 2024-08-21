import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:melody/function/provider_function.dart';
import 'package:melody/screens/music_screen.dart';
import 'package:melody/screens/search_screen.dart';
import 'package:melody/screens/settings_screen.dart';
import 'package:melody/screens/video_screen.dart';
import 'package:melody/widgets/custom_search_bar.dart';
import 'package:melody/widgets/list_tile_widget.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin {
  int _bottomBarIndex = 0;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: _buildCurvedNavigationBar(context),
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
      onTap: (index) {
        setState(() {
          _bottomBarIndex = index;
          _animationController.reset();
          _animationController.forward();
        });
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
