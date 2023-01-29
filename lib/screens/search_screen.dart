import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:gap/gap.dart';
import 'package:news_app_flutter_course/consts/list_keywords.dart';
import 'package:news_app_flutter_course/utils/utils.dart';
import 'package:provider/provider.dart';

import '../models/news_model.dart';
import '../providers/news_provider.dart';
import '../widgets/articles.dart';
import '../widgets/empty_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late final TextEditingController _searchTextController;
  late final FocusNode focusNode;

  @override
  void initState() {
    super.initState();
    _searchTextController = TextEditingController();
    focusNode = FocusNode();
  }

  @override
  void dispose() {
    if (mounted) {
      _searchTextController.dispose();
      focusNode.dispose();
    }
    super.dispose();
  }

  List<NewsModel>? searchList = [];
  bool isSearching = false;
  @override
  Widget build(BuildContext context) {
    // Size size = Utils(context).getScreenSize;
    final Color color = Utils(context).getColor;
    final newsProvider = Provider.of<NewsProvider>(context);
    return SafeArea(
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          body: Column(
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: (() {
                      focusNode.unfocus();
                      Navigator.pop(context);
                    }),
                    child: const Icon(IconlyLight.arrowLeft2),
                  ),
                  const Gap(20),
                  Flexible(
                    child: TextField(
                      focusNode: focusNode,
                      controller: _searchTextController,
                      style: TextStyle(
                        color: color,
                      ),
                      autofocus: true,
                      //textinputsaction to change the button on the keyboard
                      textInputAction: TextInputAction.search,
                      keyboardType: TextInputType.text,
                      onEditingComplete: () async {
                        searchList = await newsProvider.searchNewsProvider(
                            query: _searchTextController.text);
                        isSearching = true;
                        focusNode.unfocus();
                        setState(() {});
                      },
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.only(
                          bottom: 8 / 5,
                        ),
                        hintText: 'Search',
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        suffix: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 5,
                          ),
                          child: GestureDetector(
                            onTap: () {
                              _searchTextController.clear();
                              focusNode.unfocus();
                              isSearching = false;
                              searchList!.clear();
                              setState(() {});
                            },
                            child: const Icon(
                              Icons.close,
                              size: 18,
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const Gap(10),
              //if the user is not searching
              //if searching is true and the searchlist is empty
              if (!isSearching && searchList!.isEmpty)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: MasonryGridView.count(
                      itemCount: searchKeyWords.length,
                      crossAxisCount: 4,
                      mainAxisSpacing: 4,
                      crossAxisSpacing: 4,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () async {
                            _searchTextController.text = searchKeyWords[
                                index]; //To automatically input the suggested words into the inputfield
                            searchList = await newsProvider.searchNewsProvider(
                                query: _searchTextController.text);
                            isSearching =
                                true; //to show the state of the screen while searching
                            focusNode
                                .unfocus(); //to take the focus away from the searchfield
                            setState(() {});
                          },
                          child: Container(
                            alignment: Alignment.center,
                            margin: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: color,
                              ),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Text(searchKeyWords[index]),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              if (isSearching && searchList!.isEmpty)
                const Expanded(
                  child: EmptyNewsWidget(
                    text: 'opps!, No results found',
                    imagePath: 'assets/images/search.png',
                  ),
                ),
              if (searchList!.isNotEmpty && searchList != null)
                Expanded(
                  child: ListView.builder(
                    itemCount: searchList!.length,
                    itemBuilder: (ctx, index) {
                      return ChangeNotifierProvider.value(
                        value: searchList![index],
                        child: const ArticlesWidget(),
                      );
                    },
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}
