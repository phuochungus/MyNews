import 'package:equatable/equatable.dart';

abstract class HomeScreenEvent extends Equatable {}

class LoadNews extends HomeScreenEvent {
  @override
  List<Object?> get props => [];
}
