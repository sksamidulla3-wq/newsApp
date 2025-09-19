part of 'news_bloc.dart';

@immutable
abstract class NewsEvent {}
class TopHeadlinesFetch extends NewsEvent {
  final int? page;
  TopHeadlinesFetch({required this.page});
}
