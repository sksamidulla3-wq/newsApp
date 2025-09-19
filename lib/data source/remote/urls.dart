class Urls {
  static final String myApiKey = "e1529991501d47218250456674c4e661";

  /// base url
  static final String baseUrl = "https://newsapi.org/v2/";

  // curated news
  static final String curatedNews = "${baseUrl}top-headlines?country=us";

  //search news
  static final String searchNews = "${baseUrl}everything?q=";
}
