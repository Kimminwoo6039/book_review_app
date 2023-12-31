import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../common/model/user_model.dart';
import '../../common/repository/user_repository.dart';

class TopReviewerCubit extends Cubit<TopReviewerState> {
  final UserRepository userRepository;

  TopReviewerCubit(this.userRepository) : super(TopReviewerState()) {
    _loadTopReviewerData();
  }

  _loadTopReviewerData() async {
    emit(state.copyWith(results: []));
    var result = await userRepository.loadTopReviewerData();
    emit(state.copyWith(results: result));
  }

  void refresh() async {
    await _loadTopReviewerData();
  }

}

class TopReviewerState extends Equatable {
  final List<UserModel>? results;
  const TopReviewerState({this.results});

  TopReviewerState copyWith({
    List<UserModel>? results,
}) {
    return TopReviewerState(results: results ?? this.results);
}

  @override
  List<Object?> get props => [results];
}
