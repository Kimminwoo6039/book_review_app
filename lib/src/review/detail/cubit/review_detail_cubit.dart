

import 'package:book1/src/common/model/user_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/model/review.dart';
import '../../../common/repository/review_repository.dart';
import '../../../common/repository/user_repository.dart';

class ReviewDetailCubit extends Cubit<ReviewDetailState> {
  final ReviewRepository reviewRepository;
  final String bookId;
  final String uid;
  final UserRepository userRepository;
  ReviewDetailCubit(this.reviewRepository,this.userRepository,this.uid,this.bookId) :super(ReviewDetailState()) {
    _loadReviewInfo();
    _loadUserInfoData();
  }

  void toggleLikedReview(String myUid) async {
    print("오킹");

    if (state.review!.likedUsers == null) {
      print("시작");
      // like 이벤트 발생
      emit(state.copyWith(review: state.review!.copyWith(likedUsers: List.unmodifiable([myUid]))));
    } else {
      print("ㅋㅋ");
      if (state.review!.likedUsers!.contains(myUid)) {
        // unlike
        emit(state.copyWith(review: state.review!.copyWith(likedUsers: List.unmodifiable([...state.review!.likedUsers!.where((uid) => uid != myUid)]))));
      } else {
        // like 이벤트
        emit(state.copyWith(review: state.review!.copyWith(likedUsers: List.unmodifiable([...state.review!.likedUsers!,myUid]))));
      }
    }
    await reviewRepository.updateReview(state.review!);
  }


  void _loadReviewInfo() async {
    var reviewData = await reviewRepository.loadReviewInfo(bookId, uid);
    if (reviewData != null) {
      emit(state.copyWith(review: reviewData));
    }
  }

  void _loadUserInfoData() async {
    var findUserOne = await userRepository.findUserOne(uid);
    if (findUserOne != null) {
      emit(state.copyWith(userModel: findUserOne));
    }
  }

}


class ReviewDetailState extends Equatable {
  final Review? review;
  final UserModel? userModel;
  const ReviewDetailState({
    this.review,
    this.userModel,
});

  ReviewDetailState copyWith({
    Review? review,
    UserModel? userModel,
}) {
    return ReviewDetailState(review: review ?? this.review, userModel: userModel ?? this.userModel);
}

  @override
  List<Object?> get props => [review,userModel];
}