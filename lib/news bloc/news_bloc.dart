import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsapp/data%20source/remote/api_helper.dart';

import '../data source/remote/app_exceptions.dart';
import '../data source/remote/urls.dart';
import '../model/api_model.dart';

part 'news_event.dart';

part 'news_state.dart';

class NewsBloc extends Bloc<NewsEvent, NewsState> {
  APiHelper apiHelper;

  NewsBloc({required this.apiHelper}) : super(NewsInitial()) {
    on<TopHeadlinesFetch>((event, emit) async {
      emit(NewsLoading());
      try {
        var rawNewsData = await apiHelper.getAPI(
          "${Urls.curatedNews}&page=${event.page}",
        );
        var newsModel = NewsModel.fromJson(rawNewsData);
        emit(NewsLoaded(news: newsModel));
      } catch (e) {
        emit(NewsError(error: (e as ErrorExceptions).toString()));
      }
    });
  }
}
