import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsapp/model/api_model.dart';
import 'package:newsapp/news%20bloc/news_bloc.dart';
import 'package:newsapp/screens/searchBloc/search_bloc.dart';
import 'package:newsapp/screens/searchScreen.dart';
import 'package:newsapp/screens/secondpage.dart';

import 'data source/remote/api_helper.dart';

void main() {
  runApp(
    MultiBlocProvider(providers: [
      BlocProvider(
        create: (ctx) => NewsBloc(apiHelper: APiHelper()),
      ),
      BlocProvider(
        create: (ctx) => SearchBloc(apiHelper: APiHelper()),
      ),
    ], child: MyApp())
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter News App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter Demo News App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<NewsModel?>? newsModel;
  List<ContentModel> contentsList = [];
  int page = 0;
  num? totalPage;
  ScrollController? scrollController;

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Load top headlines initially
    scrollController = ScrollController()
      ..addListener(() {
        if (scrollController!.position.pixels ==
            scrollController!.position.maxScrollExtent) {
          if (totalPage != null && page < totalPage!) {
            page++;
            BlocProvider.of<NewsBloc>(
              context,
            ).add(TopHeadlinesFetch(page: page));
          } else {
            print("No more pages");
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("No more pages"),
              ),
            );
          }
        }
      });
    BlocProvider.of<NewsBloc>(context).add(TopHeadlinesFetch(page: page));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: "Search news...",
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    String query = _searchController.text.trim();
                    String safeQuery = Uri.encodeComponent(query);
                    // Handle search functionality here
                    if (_searchController.text.isNotEmpty) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (ctx) {
                            return SearchScreen(
                              query: safeQuery.isEmpty ? "" : safeQuery,
                            );
                          },
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Please Enter Something")),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            "Top Headlines",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          BlocListener<NewsBloc, NewsState>(
            listener: (ctx, state) {
              if (state is NewsError) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(state.error)));
              }
              if (state is NewsLoaded) {
                totalPage = state.news.totalResults! % 15 == 0
                    ? state.news.totalResults! ~/ 15
                    : state.news.totalResults! ~/ 15 + 1;
                newsModel = Future.value(state.news);
                if (page == 0) {
                  contentsList = state.news.articles!;
                } else {
                  contentsList.addAll(state.news.articles!);
                }
                setState(() {});
              }
              if (state is NewsLoading) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Loading..."),
                        CircularProgressIndicator(),
                      ],
                    ),
                  ),
                );
              }
            },
            child: contentsList.isNotEmpty
                ? Expanded(
                    child: ListView.builder(
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
                            title: Text(
                              contentsList[index].title ?? "No Title",
                            ),
                            subtitle: Text(
                              contentsList[index].description ??
                                  "No Description",
                            ),
                            trailing: Icon(Icons.arrow_forward),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (ctx) => SecondScreen( contentModel: contentsList[index]),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  )
                : Center(child: CircularProgressIndicator()),
          ),
        ],
      ),
    );
  }
}
