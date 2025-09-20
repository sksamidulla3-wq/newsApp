import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsapp/model/api_model.dart';
import 'package:newsapp/screens/searchBloc/search_bloc.dart';
import 'package:newsapp/screens/secondpage.dart';

class SearchScreen extends StatefulWidget {
  String query = "";

  SearchScreen({required this.query});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  ScrollController scrollController = ScrollController();
  TextEditingController searchController = TextEditingController();
  NewsModel? newsModel;
  List<ContentModel> contentsList = [];
  int page = 0;
  num? totalPage;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    searchController.text = widget.query;
    scrollController = ScrollController()
      ..addListener(() {
        if (scrollController.position.pixels ==
            scrollController.position.maxScrollExtent) {
          if (totalPage != null && page < totalPage!) {
            page++;
            BlocProvider.of<SearchBloc>(
              context,
            ).add(SearchNewsEvent(query: searchController.text, page: page));
          } else {
            print("No more pages");
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text("No more pages")));
          }
        }
      });

    BlocProvider.of<SearchBloc>(
      context,
    ).add(SearchNewsEvent(query: searchController.text, page: page));
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(title: Text("Search Screen")),
      body: BlocListener<SearchBloc, SearchState>(
        listener: (_, state) {
          if (state is SearchError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.error)));
          }
          if (state is SearchLoaded) {
            totalPage = state.news.totalResults! % 15 == 0
                ? state.news.totalResults! ~/ 15
                : state.news.totalResults! ~/ 15 + 1;
            if (page == 0) {
              contentsList = state.news.articles!;
            } else {
              contentsList.addAll(state.news.articles!);
            }
            setState(() {});
          }
          if (state is SearchLoading) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Text("Loading..."), CircularProgressIndicator()],
                ),
              ),
            );
          }
        },
        child: contentsList.isNotEmpty
            ? ListView.builder(
                controller: scrollController,
                itemCount: contentsList.length,
                itemBuilder: (ctx, index) {
                  return Card(
                    child: ListTile(
                      leading:
                          contentsList[index].urlToImage != null &&
                              contentsList[index].urlToImage!.isNotEmpty
                          ? Image.network(
                              contentsList[index].urlToImage!,
                              width: 80,
                              fit: BoxFit.cover,
                              errorBuilder: (ctx, error, stack) =>
                                  Icon(Icons.broken_image),
                            )
                          : Icon(Icons.image_not_supported),
                      title: Text(contentsList[index].title ?? "No Title"),
                      subtitle: Text(
                        contentsList[index].description ?? "No Description",
                      ),
                      trailing: Icon(Icons.arrow_forward),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (ctx) =>
                                SecondScreen(contentModel: contentsList[index]),
                          ),
                        );
                      },
                    ),
                  );
                },
              )
            : Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
