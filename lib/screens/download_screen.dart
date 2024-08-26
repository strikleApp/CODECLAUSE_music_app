import 'package:flutter/material.dart';
import 'package:melody/function/provider_function.dart';
import 'package:melody/modals/DownloadClass.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class DownloadScreen extends StatelessWidget {
  const DownloadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    List<DownloadClass> downloads =
        Provider.of<ProviderFunction>(context).downloads;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Download Screen'),
      ),
      body: ListView.builder(
        itemCount: downloads.length,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.all(10),
            color: Theme.of(context).colorScheme.onSecondary,
            child: ListTile(
              title: Text(
                downloads[index].title,
                style: TextStyle(
                  color: downloads[index].progress == -1
                      ? Colors.red
                      : downloads[index].progress == 100
                          ? Theme.of(context).colorScheme.secondary
                          : Theme.of(context).colorScheme.primary,
                ),
              ),
              subtitle: downloads[index].progress == -1
                  ? const Text('Download Error')
                  : downloads[index].progress == 100
                      ? const Text('Download Completed')
                      : Row(
                          children: [
                            Text(
                              'Progress: ${downloads[index].progress.toStringAsFixed(2)}%',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                            const SizedBox(width: 10),
                            SizedBox(
                              width: 40.w,
                              child: LinearProgressIndicator(
                                value: downloads[index].progress / 100,
                                backgroundColor: Colors.grey,
                                valueColor: AlwaysStoppedAnimation(
                                  Theme.of(context).colorScheme.primary,
                                ),
                              ),
                            ),
                          ],
                        ),
            ),
          );
        },
      ),
    );
  }
}