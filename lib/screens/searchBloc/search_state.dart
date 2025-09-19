part of 'search_bloc.dart';

@immutable
abstract class SearchState {}

final class SearchInitial extends SearchState {}
final class SearchLoading extends SearchState {}
final class SearchLoaded extends SearchState {
  NewsModel news;
  SearchLoaded({required this.news});
}
final class SearchError extends SearchState {
  final String error;
  SearchError({required this.error});
}
