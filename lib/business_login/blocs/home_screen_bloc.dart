import 'package:bloc/bloc.dart';
import 'package:news_app/data/repositories/news_repository.dart';

import '../../data/models/news.dart';
import '../../data/repositories/news_provider_sqflite.dart';
import './home_screen_event.dart';
import './home_screen_state.dart';

class HomeScreenBloc extends Bloc<HomeScreenEvent, HomeScreenState> {
  HomeScreenBloc(this.newsRepository) : super(const HomeScreenState()) {
    on<FetchNewsFromAPI>(_onNewsFetching);
    on<RetrieveNewsFromInternalDb>(_onNewsRetrieving);
  }
  final NewsRepository newsRepository;
  int numberOfFetchedNewsInJSON = -1;
  int totalNumberOfPage = 0;

  Future<void> _onNewsRetrieving(
      HomeScreenEvent event, Emitter<HomeScreenState> emit) async {
    if (state.status != NewsStatus.initial) return;
    try {
      List<News> fetchedNews = await SqfliteHelper.getAllNews();
      totalNumberOfPage = fetchedNews.length ~/ 20;
      emit(state.copyWith(
          status: NewsStatus.success,
          newsGroup: List.of(state.newsGroup)..addAll(fetchedNews),
          hasReachMax: false));
      add(FetchNewsFromAPI());
    } catch (e) {
      emit(state.copyWith(status: NewsStatus.failure));
    }
  }

  Future<void> _onNewsFetching(
      HomeScreenEvent event, Emitter<HomeScreenState> emit) async {
    if (state.hasReachMax) return;
    if (state.status == NewsStatus.success) {
      try {
        List<News> fetchedNews =
            await newsRepository.getNewsOnPage(totalNumberOfPage + 1);
        if (fetchedNews.isNotEmpty) {
          totalNumberOfPage++;
          await SqfliteHelper.insertAll(fetchedNews);
          if (numberOfFetchedNewsInJSON == -1) {
            numberOfFetchedNewsInJSON = fetchedNews.length;
          }
          if (fetchedNews.length < numberOfFetchedNewsInJSON) {
            emit(state.copyWith(
                status: NewsStatus.success,
                newsGroup: List.of(state.newsGroup)..addAll(fetchedNews),
                hasReachMax: true));
          } else {
            emit(state.copyWith(
                status: NewsStatus.success,
                newsGroup: List.of(state.newsGroup)..addAll(fetchedNews),
                hasReachMax: false));
          }
        } else if (fetchedNews.isEmpty) {
          emit(state.copyWith(
            status: NewsStatus.success,
            hasReachMax: true,
          ));
        }
      } catch (e) {
        emit(state.copyWith(status: NewsStatus.failure));
      }
    }
  }
}
