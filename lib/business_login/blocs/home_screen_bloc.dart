import 'package:bloc/bloc.dart';
import 'package:news_app/data/repositories/news_repository.dart';

import '../../data/models/news.dart';

abstract class HomeScreenEvent {}

class LoadNews extends HomeScreenEvent {}

abstract class HomeScreenState {}

class HomeScreenInitial extends HomeScreenState {}

class LoadingNewsState extends HomeScreenState {}

class LoadedNewsState extends HomeScreenState {
  final List<News> payload;
  LoadedNewsState({required this.payload});
}

class LoadedFailState extends HomeScreenState {
  final String errorMessage;
  LoadedFailState({required this.errorMessage});
}

class HomeScreenBloc extends Bloc<HomeScreenEvent, HomeScreenState> {
  HomeScreenBloc(this._newsRepository) : super(HomeScreenInitial()) {
    on<LoadNews>((event, emit) async {
      emit(LoadingNewsState());
      try {
        var newsGroup = await _newsRepository.getAll();
        emit(LoadedNewsState(payload: newsGroup));
      } catch (e) {
        emit(LoadedFailState(errorMessage: 'Fail to load'));
      }
    });
  }

  final NewsRepository _newsRepository;
}
