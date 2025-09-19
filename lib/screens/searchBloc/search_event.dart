part of 'search_bloc.dart';

@immutable
abstract class SearchEvent {}

class SearchNewsEvent extends SearchEvent {
  String query;
  int? page;

  SearchNewsEvent({required this.query, required this.page});
}
