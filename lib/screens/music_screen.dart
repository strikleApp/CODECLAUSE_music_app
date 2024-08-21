import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:melody/db/hive.dart';
import 'package:melody/widgets/playPauseButton.dart';
import 'package:melody/widgets/roundedButton.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class MusicScreen extends StatelessWidget {
  const MusicScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme
          .of(context)
          .colorScheme
          .onPrimary,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Expanded(
            child: MusicListView(),
          ),
          SizedBox(
            height: 2.h,
            child: AnimatedTextKit(
              repeatForever: true,
              animatedTexts: [
                FlickerAnimatedText("Playing now", textAlign: TextAlign.center),
                FlickerAnimatedText('null', textAlign: TextAlign.center),
              ],
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Slider(
                min: 0.0,
                max: 10,
                value: Duration.zero.inSeconds.toDouble(),
                onChanged: (double value) {},
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.sp),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("00:00"),
                    Text('00:00'),
                  ],
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const ShuffleWidget(),
              RoundButton(
                size: 50,
                icon: Icons.fast_rewind_rounded,
                function: () async {},
              ),
              const PlayPauseButton(),
              RoundButton(
                size: 50,
                icon: Icons.fast_forward_rounded,
                function: () async {},
              ),
              RoundButton(
                size: 25,
                icon: Icons.replay,
                function: () async {},
              ),
            ],
          ),
          SizedBox(
            height: 4.h,
          ),
        ],
      ),
    );
  }
}

class MusicListView extends StatelessWidget {
  const MusicListView({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: HiveDB
          .getSongModals()
          .length,
      itemBuilder: (BuildContext context, int index) {
        return InkWell(
          onTap: () async {},
          onLongPress: () {},
          child: ListTile(
            leading: Text(
              '${index + 1}',
              style: Theme
                  .of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(color: Theme
                  .of(context)
                  .colorScheme
                  .primary),
            ),
            title: TextField(
              onSubmitted: (value) {},
              autofocus: false,
              enabled: false,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                hintText: HiveDB.getSongModals()[index].name,
                hintStyle: Theme
                    .of(context)
                    .textTheme
                    .bodyLarge
                    ?.copyWith(color: Theme
                    .of(context)
                    .colorScheme
                    .primary),
                border: InputBorder.none,
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Theme
                      .of(context)
                      .primaryColor),
                ),
              ),
              style: Theme
                  .of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(color: Theme
                  .of(context)
                  .colorScheme
                  .primary),
            ),
            trailing: PopupMenuButton<String>(
              iconColor: Theme
                  .of(context)
                  .colorScheme
                  .primary,
              color: Theme
                  .of(context)
                  .colorScheme
                  .onPrimary,
              onSelected: (String value) {
                _handleClick(
                    value: value, videoId: '', context: context, name: '');
              },
              itemBuilder: (context) {
                return {
                  'Play next',
                  'Download Video',
                  'Rename',
                  'Remove from playlist',
                  'Delete file from device',
                  'Share'
                }.map(
                      (String choice) {
                    return PopupMenuItem<String>(
                      value: choice,
                      child: Text(choice),
                    );
                  },
                ).toList();
              },
            ),
          ),
        );
      },
    );
  }

  void _handleClick({
    required String value,
    required String videoId,
    required BuildContext context,
    required String name,
  }) {
    switch (value) {
      case 'Play next':
        break;
      case 'Rename':
        break;
      case 'Remove from playlist':
        break;
      case 'Delete file from device':
        break;
      case 'Download Video':
        break;
      case 'Share':
        break;
      default:
        break;
    }
  }
}
