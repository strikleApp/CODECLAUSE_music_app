import 'package:flutter/material.dart';
import 'package:melody/function/provider_function.dart';
import 'package:melody/screens/download_screen.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

const kStreamAudioOption = 'Stream Audio';
const kDownloadAudioOption = 'Download Audio';
const kDownloadVideoOption = 'Download Video';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  SettingsScreenState createState() => SettingsScreenState();
}

class SettingsScreenState extends State<SettingsScreen> {
  final _onVideoTapOptions = [
    kStreamAudioOption,
    kDownloadAudioOption,
    kDownloadVideoOption
  ];

  @override
  Widget build(BuildContext context) {
    String selectedOnTapOption =
        Provider.of<ProviderFunction>(context).selectedOnTapOption;
    int selectedIndex = _onVideoTapOptions.indexOf(selectedOnTapOption);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionHeader('When tap on a video:'),
            _onVideoTapButton(selectedIndex),
            const SizedBox(
              height: 20,
            ),
            ListTile(
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const DownloadScreen())),
              leading: Icon(
                Icons.download,
                color: Theme.of(context).colorScheme.primary,
                size: 25.sp,
              ),
              title: Text(
                "Downloads",
                style: TextStyle(fontSize: 20.sp),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _sectionHeader(String title) {
    return Container(
      padding: const EdgeInsets.only(top: 20.0, bottom: 10.0),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
      ),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _onVideoTapButton(int selectedIndex) {
    return _buttonList(_onVideoTapOptions, selectedIndex);
  }

  Widget _buttonList(List<String> options, int selectedIndex) {
    return Wrap(
      spacing: 10.0,
      children: options.asMap().entries.map((entry) {
        final index = entry.key;
        final title = entry.value;
        return _selectableButton(title, index, selectedIndex);
      }).toList(),
    );
  }

  Widget _selectableButton(String title, int value, int selectedIndex) {
    final buttonStyle = ButtonStyle(
      backgroundColor: WidgetStateProperty.all(
        selectedIndex == value
            ? Theme.of(context).colorScheme.primary
            : Theme.of(context).colorScheme.onSecondary,
      ),
      foregroundColor: WidgetStateProperty.all(
        selectedIndex == value ? Colors.white : Colors.black,
      ),
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      ),
    );

    return OutlinedButton(
      onPressed: () {
        Provider.of<ProviderFunction>(context, listen: false)
            .setSelectedOption(option: title);
      },
      style: buttonStyle,
      child: Text(title),
    );
  }
}
