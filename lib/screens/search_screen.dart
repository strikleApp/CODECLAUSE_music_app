import 'package:flutter/material.dart';
import 'package:melody/function/provider_function.dart';
import 'package:melody/widgets/custom_search_bar.dart';
import 'package:melody/widgets/list_tile_widget.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchTextEditingController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    VideoSearchList? videoSearchList =
        Provider.of<ProviderFunction>(context).video;
    return Stack(
      children: [
        ListView.builder(
          itemCount: videoSearchList?.length ?? 0,
          itemBuilder: (context, index) {
            Video video = videoSearchList![index];
            return ListWidget(videoDetails: video);
          },
        ),
        SafeArea(
          child: AnimSearchBar(
            prefixIcon: Icon(
              Icons.search_rounded,
              color: Theme.of(context).colorScheme.primary,
            ),
            color: Theme.of(context).colorScheme.onPrimary,
            rtl: true,
            width: 100.w,
            textController: _searchTextEditingController,
            suffixIcon: Icon(
              Icons.search_rounded,
              color: Theme.of(context).colorScheme.primary,
            ),
            onSuffixTap: () {},
            onCompleteFunction: () {},
          ),
        )
      ],
    );
  }
}
