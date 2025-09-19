class NewsModel {
  String? status;
  int? totalResults;
  List<ContentModel>? articles;

  NewsModel({
    required this.status,
    required this.totalResults,
    required this.articles,
  });

  factory NewsModel.fromJson(Map<String, dynamic> json) {
    List<ContentModel> articles = [];
    for (Map<String, dynamic> each in json['articles']) {
      articles.add(ContentModel.fromJson(each));
    }

    return NewsModel(
      status: json['status'],
      totalResults: json['totalResults'],
      articles: articles,
    );
  }
}

class ContentModel {
  String? author;
  String? title;
  String? description;
  String? url;
  String? urlToImage;
  String? publishedAt;
  String? content;
  SourceModel? source;

  ContentModel({
    required this.author,
    required this.title,
    required this.description,
    required this.url,
    required this.urlToImage,
    required this.publishedAt,
    required this.content,
    required this.source,
  });

  factory ContentModel.fromJson(Map<String, dynamic> json) {
    return ContentModel(
      author: json['author'],
      title: json['title'],
      description: json['description'],
      url: json['url'],
      urlToImage: json['urlToImage'],
      publishedAt: json['publishedAt'],
      content: json['content'],
      source: SourceModel.fromJson(json['source']),
    );
  }
}

class SourceModel {
  String? id;
  String? name;

  SourceModel({required this.id, required this.name});

  factory SourceModel.fromJson(Map<String, dynamic> json) {
    return SourceModel(id: json['id'], name: json['name']);
  }
}
