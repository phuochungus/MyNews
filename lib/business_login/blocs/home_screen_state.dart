import 'package:equatable/equatable.dart';

import '../../data/models/news.dart';

enum NewsStatus { initial, success, failure }

abstract class HomeScreenState extends Equatable {}

class HomeScreenInitial extends HomeScreenState {
  @override
  List<Object?> get props => [];
}

class LoadingNewsState extends HomeScreenState {
  @override
  List<Object?> get props => [];
}

class LoadedNewsState extends HomeScreenState {
  final List<News> payload;
  LoadedNewsState({required this.payload});

  @override
  List<Object?> get props => [payload];
}

class LoadedFailState extends HomeScreenState {
  final String errorMessage;
  LoadedFailState({required this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];
}
