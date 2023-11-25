import 'package:book1/src/common/model/book_review_info.dart';
import 'package:book1/src/common/model/naver_book_info.dart';
import 'package:book1/src/common/model/review.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../common/repository/book_review_info_repository.dart';
import '../../common/repository/review_repository.dart';

class ReviewCubit extends Cubit<ReviewState> {
  final BookReviewInfoRepository bookReviewInfoRepository;
  final ReviewRepository reviewRepository;

  ReviewCubit(this.bookReviewInfoRepository, this.reviewRepository, String uid,
      NaverBookInfo naverBookInfo)
      : super(ReviewState(
      review: Review(
          bookId: naverBookInfo.isbn,
          reviewerUid: uid,
          naverBookInfo: naverBookInfo) // 초기화시  누가쓴지 값을 갖고 초기화..
  ));

  changeValue(double value) {
    print("카운트 $value");
    emit(state.copyWith(review: state.review!.copyWith(value: value)));
  }

  changeReview(String review) {
    print("내용 $review");
    emit(state.copyWith(review: state.review!.copyWith(review: review)));
  }

  save() async {
    var bookId = state.review!.bookId!;
    var bookReviewInfo = await bookReviewInfoRepository.loadBookReviewInfo(
        bookId);


    if (bookReviewInfo == null) {
      //insert
      var bookReivewInfo2 = BookReivewInfo(
        bookId: bookId,
        totalCount: state.review!.value,
        createAt: DateTime.now(),
        updateAt: DateTime.now(),
        reviewerUids: [state.review!.reviewerUid!],
        naverBookInfo: state.review!.naverBookInfo!,
      );

      bookReviewInfoRepository.createBookReviewInfo(bookReivewInfo2);
    } else {
      //update
      bookReviewInfo.reviewerUids!.add(state.review!.reviewerUid!);
    var result =   bookReviewInfo.copyWith(
        totalCount: bookReviewInfo.totalCount! + state.review!.value!,
        reviewerUids: bookReviewInfo.reviewerUids!.toSet().toList(),
        updateAt: DateTime.now(),
      );
      bookReviewInfoRepository.updateBookReviewInfo(result);
    }

    // var now = DateTime.now();
    // emit(state.copyWith(
    //     review: state.review!.copyWith(createdAt: now, updateAt: now)));
    // await reviewRepository.createReview(state.review!);
  }
}

class ReviewState extends Equatable {
  final Review? review;

  const ReviewState({
    this.review,
  });

  ReviewState copyWith({
    Review? review,
  }) {
    return ReviewState(review: review ?? this.review);
  }

  @override
  List<Object?> get props => [review];
}
