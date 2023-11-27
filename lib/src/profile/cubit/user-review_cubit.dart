
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../common/model/review.dart';
import '../../common/repository/review_repository.dart';

class UserReviewCubit extends Cubit<UserReviewState> {
  final ReviewRepository reviewRepository;
  String uid;
  UserReviewCubit(this.reviewRepository,this.uid) : super(UserReviewState()) {
    _loadMyAllReviews();
  }

  void _loadMyAllReviews() async {
    var result = await reviewRepository.loadMyAllReviews(uid);
    emit(state.copyWith(results: result));
}
}

class UserReviewState extends Equatable {
  final List<Review>? results;
  const UserReviewState({this.results = const []});

  UserReviewState copyWith({
    List<Review>? results,
}) {
    return UserReviewState(results: results ?? this.results);
  }

  @override
  List<Object?> get props => [results];

}