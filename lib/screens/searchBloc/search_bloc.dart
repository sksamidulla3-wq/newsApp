import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data source/remote/api_helper.dart';
import '../../data source/remote/app_exceptions.dart';
import '../../data source/remote/urls.dart';
import '../../model/api_model.dart';

part 'search_event.dart';

part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  APiHelper apiHelper;

  SearchBloc({required this.apiHelper}) : super(SearchInitial()) {
    on<SearchNewsEvent>((event, emit) async {
      emit(SearchLoading());
      try {
        var mainUrl =  event.query.isNotEmpty ? Urls.searchNews + event.query : Urls.curatedNews;
       var rawNewsData = await apiHelper.getAPI(mainUrl);
        var newsModel = NewsModel.fromJson(rawNewsData);
        emit(SearchLoaded(news: newsModel));
      } catch (e) {
        emit(SearchError(error: (e as ErrorExceptions).toString()));
      }
    });
  }
}
