part of 'news_bloc.dart';

@immutable
abstract class NewsState {}

final class NewsInitial extends NewsState {}
final class NewsLoading extends NewsState {}
final class NewsLoaded extends NewsState {
  NewsModel news;
  NewsLoaded({required this.news});
}
final class NewsError extends NewsState {
  final String error;
  NewsError({required this.error});
}

