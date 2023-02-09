import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:news_app/data/repositories/news_repository.dart';

import './home_screen_event.dart';
import './home_screen_state.dart';

class HomeScreenBloc extends Bloc<HomeScreenEvent, HomeScreenState> {
  HomeScreenBloc(this._newsRepository) : super(HomeScreenInitial()) {
    on<LoadNews>((event, emit) async {
      try {
        var newsGroup = await _newsRepository.getAll();
        emit(LoadedNewsState(payload: newsGroup));
      } on DioError catch (e) {
        emit(LoadedFailState(errorMessage: e.message));
      }
    });
  }

  final NewsRepository _newsRepository;
}
