
// import 'package:assets_audio_player/assets_audio_player.dart';
// import 'package:flutter/material.dart';
// import 'package:group_button/group_button.dart';
// import 'package:liquid_swipe/liquid_swipe.dart';
// import 'package:melody/constants/shared_preferences_keys.dart';
// import 'package:melody/screens/loading_screen.dart';
// import 'package:restart_app/restart_app.dart';
//
// const String startingText =
//     'Hey! Welcome to Melody! We are excited to see you here. Let\'s get started '
//     'by sliding to your left.';
// const String secondText =
//     'We would like you to review some of our settings....... like.... App Theme,,,Download Mode,,, and quality '
//     'which is currently available to highest only........ And Of course you can always change these later.';
// const String thirdText =
//     'Hooray!!! ALL SET! ,,,,, You are good to go... Enjoy your favorite songs on Melody.'
//     'Please let us know your experience on Melody on Google Play Store. We will be glad to see your feedback. Thank You!';
//
// class TTSScreen extends StatefulWidget {
//   const TTSScreen({super.key});
//
//   @override
//   _TTSScreenState createState() => _TTSScreenState();
// }
//
// class _TTSScreenState extends State<TTSScreen>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _animationController;
//   late Animation<double> _animation;
//   final _assetsAudioPlayer = AssetsAudioPlayer();
//
//   @override
//   void initState() {
//     _animationController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 500),
//     );
//     _animation =
//         CurvedAnimation(parent: _animationController, curve: Curves.elasticOut);
//     _assetsAudioPlayer.open(Audio('audio/first.mp3'));
//     super.initState();
//   }
//
//   @override
//   void dispose() {
//     _animationController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final List<Widget> pages = [
//       Container(
//         width: MediaQuery.of(context).size.width,
//         height: MediaQuery.of(context).size.height,
//         color: Colors.green,
//         child: SafeArea(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               const Column(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     'Welcome',
//                     style: TextStyle(fontSize: 65, color: Colors.white),
//                   ),
//                   Text(
//                     'Enjoy life by listening music! \nRelax your mind and soul.',
//                     style: TextStyle(fontSize: 19, color: Colors.white),
//                   ),
//                 ],
//               ),
//               const Text(
//                 'Melody',
//                 style: TextStyle(
//                     fontSize: 80, fontFamily: 'Damion', color: Colors.white),
//               ),
//               Container(
//                 padding: const EdgeInsets.all(6.0),
//                 decoration: const BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.all(
//                     Radius.circular(20),
//                   ),
//                 ),
//                 child: const Text(
//                   "Let's get started!",
//                   style: TextStyle(fontSize: 40, color: Colors.green),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//       Container(
//         width: MediaQuery.of(context).size.width,
//         height: MediaQuery.of(context).size.height,
//         color: Colors.redAccent,
//         child: SafeArea(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               const Text(
//                 'We would like you to review some of our settings.',
//                 textAlign: TextAlign.center,
//                 style: TextStyle(fontSize: 40, color: Colors.white),
//               ),
//               Container(
//                 decoration: const BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.all(
//                     Radius.circular(35),
//                   ),
//                 ),
//                 height: MediaQuery.of(context).size.height * 0.48,
//                 child: Column(
//                   children: [
//                     const MenuTextIcon(icon: Icons.stream, text: 'Download Mode'),
//                     GroupedButtonWidget(
//                         function: (index, onSelected) {
//                           String mode = 'audio';
//                           if (index == 0) {
//                             mode = 'audio';
//                           } else if (index == 1) {
//                             mode = 'video';
//                           }
//
//                           ///Todo:
//                           // Provider.of<ProviderFunction>(context, listen: false)
//                           //     .setDownloadMode(mode: _mode);
//                         },
//                         buttons: const ['Audio', 'Video'],
//                         selectedButton: 0),
//                     const MenuTextIcon(icon: Icons.high_quality, text: 'Quality'),
//                     GroupedButtonWidget(
//                         function: (index, onSelected) {},
//                         buttons: const ['Highest'],
//                         selectedButton: 0),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//       Container(
//         width: MediaQuery.of(context).size.width,
//         height: MediaQuery.of(context).size.height,
//         color: Colors.blueAccent,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           children: [
//             const Text(
//               'All Set!',
//               style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 65,
//                   fontWeight: FontWeight.bold),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Container(
//                 height: MediaQuery.of(context).size.height * 0.3,
//                 decoration: const BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.all(
//                     Radius.circular(35),
//                   ),
//                 ),
//                 child: const Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     Text(
//                       'Thank you for downloading our app. \nEnjoy your songs on Melody.',
//                       textAlign: TextAlign.center,
//                       style: TextStyle(color: Colors.blueAccent, fontSize: 20),
//                     ),
//                     Text(
//                       'If have a good time using our app please give us your'
//                       ' valuable review and feedback on play store.',
//                       textAlign: TextAlign.center,
//                       style: TextStyle(color: Colors.blueAccent, fontSize: 20),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             const Text(
//               'THANK YOU!',
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 color: Colors.white,
//                 fontSize: 65,
//               ),
//             ),
//           ],
//         ),
//       ),
//       Container(
//         width: MediaQuery.of(context).size.width,
//         height: MediaQuery.of(context).size.height,
//         color: Theme.of(context).primaryColor,
//         child: Center(
//           child: ScaleTransition(
//             scale: _animation,
//             child: const Text(
//               'Let\'s go!',
//               style: TextStyle(fontSize: 80, color: Colors.white),
//             ),
//           ),
//         ),
//       ),
//     ];
//     return Scaffold(
//       backgroundColor: Theme.of(context).primaryColor,
//       body: LiquidSwipe.builder(
//         onPageChangeCallback: (value) async {
//           if (value == 0) {}
//           if (value == 1) {
//             await _assetsAudioPlayer.stop();
//             _assetsAudioPlayer.open(
//               Audio('audio/second.mp3'),
//             );
//           }
//           if (value == 2) {
//             await _assetsAudioPlayer.stop();
//             _assetsAudioPlayer.open(
//               Audio('audio/third.mp3'),
//             );
//           }
//           _animationController.reset();
//           if (value == 3) {
//             await _assetsAudioPlayer.stop();
//             await _animationController.forward();
//             await LoadingScreen.preferences.setBool(spFirstTime, false);
//             Restart.restartApp();
//           }
//         },
//         enableLoop: false,
//         itemCount: pages.length,
//         itemBuilder: (context, index) {
//           return pages[index];
//         },
//         positionSlideIcon: 0.96,
//         slideIconWidget: ElevatedButton.icon(
//           onPressed: null,
//           icon: const Icon(
//             Icons.arrow_forward_ios_rounded,
//             color: Colors.white,
//             size: 50,
//           ),
//           label: const Text(
//             'Slide',
//             style: TextStyle(
//               fontSize: 30,
//               color: Colors.white,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class MenuTextIcon extends StatelessWidget {
//   final IconData icon;
//   final String text;
//
//   const MenuTextIcon({super.key, required this.icon, required this.text});
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(
//             icon,
//             size: 50,
//             color: Colors.redAccent,
//           ),
//           Text(
//             text,
//             style: const TextStyle(color: Colors.redAccent, fontSize: 35),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class GroupedButtonWidget extends StatelessWidget {
//   final List<String> buttons;
//   final void Function(int index, bool selected) function;
//   final int selectedButton;
//
//   const GroupedButtonWidget(
//       {super.key, required this.function,
//       required this.buttons,
//       required this.selectedButton});
//
//   @override
//   Widget build(BuildContext context) {
//     return Flexible(
//       child: GroupButton(
//         buttons: buttons,
//         onSelected: (s, index, selected) {
//           function(index, selected);
//         },
//         isRadio: true,
//       ),
//     );
//   }
// }
