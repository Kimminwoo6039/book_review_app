import 'package:book1/src/common/enum/common_state_status.dart';
import 'package:book1/src/common/model/book_review_info.dart';
import 'package:book1/src/common/model/naver_book_info.dart';
import 'package:book1/src/common/model/review.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/repository/book_review_info_repository.dart';
import '../../../common/repository/review_repository.dart';

class ReviewWriteCubit extends Cubit<ReviewWriteState> {
  final BookReviewInfoRepository bookReviewInfoRepository;
  final ReviewRepository reviewRepository;

  ReviewWriteCubit(this.bookReviewInfoRepository, this.reviewRepository, String uid,
      NaverBookInfo naverBookInfo)
      : super(ReviewWriteState(
            review: Review(
                bookId: naverBookInfo.isbn,
                reviewerUid: uid,
                naverBookInfo: naverBookInfo) // 초기화시  누가쓴지 값을 갖고 초기화..
            )) {
    _loadReviewInfo();
  }

  // 조회
  _loadReviewInfo() async {
    var reviewInfo = await reviewRepository.loadReviewInfo(
        state.review!.bookId!, state.review!.reviewerUid!);

    if (reviewInfo == null) {
      // 리뷰작성 이력 없는책
      emit(state.copyWith(
          isEditModel: false,
          review: reviewInfo,
          beforevalue: reviewInfo?.value));
    } else {
      // 리뷰 작성한 이력 있음
      emit(state.copyWith(
          isEditModel: true,
          review: reviewInfo,
          beforevalue: reviewInfo?.value));
    }

  }

  changeValue(double value) {
    print("카운트 $value");
    emit(state.copyWith(review: state.review!.copyWith(value: value)));
  }

  changeReview(String review) {
    print("내용 $review");
    emit(state.copyWith(review: state.review!.copyWith(review: review)));
  }

  Future<void> insert() async {
    var now = DateTime.now();
    emit(state.copyWith(
        review: state.review!.copyWith(createdAt: now, updateAt: now)));
    await reviewRepository.createReview(state.review!);

    var bookId = state.review!.bookId!;
    var bookReviewInfo =
        await bookReviewInfoRepository.loadBookReviewInfo(bookId);

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
      bookReviewInfo = bookReviewInfo.copyWith(
        totalCount: bookReviewInfo.totalCount! - (state.beforevalue ?? 0) + state.review!.value!, // 수정할때 기존꺼 빼고 다시 넣음
        reviewerUids: bookReviewInfo.reviewerUids!.toSet().toList(),
        updateAt: DateTime.now(),
      );
      bookReviewInfoRepository.updateBookReviewInfo(bookReviewInfo);
    }
  }

  Future<void> update() async {
    var updateData = state.review!
        .copyWith(updateAt: DateTime.now()); // review = 수정값이 있기때문에 수정날자만
    await reviewRepository.updateReview(updateData);

    var bookReviewInfo =
        await bookReviewInfoRepository.loadBookReviewInfo(updateData.bookId!);

    if (bookReviewInfo != null) {
      var result = bookReviewInfo.copyWith(
          updateAt: DateTime.now(),
          totalCount:
          bookReviewInfo.totalCount! - (state.beforevalue!) + state.review!.value! // 수정할때 기존꺼 빼고 다시 넣음)
      );
      await bookReviewInfoRepository.updateBookReviewInfo(result);
    }


  }

  save() async {
    emit(state.copyWith(status: CommonStatus.loading));
    var message = "";
    if (state.isEditModel == true) {
      await update();
      message = "리뷰가 수정 되었습니다";
    } else {
      await insert();
      message = "리뷰가 등록 되었습니다";
    }

    emit(state.copyWith(status: CommonStatus.loaded,message: message));

  }
}

class ReviewWriteState extends Equatable {
  final CommonStatus status;
  final Review? review;
  final bool? isEditModel;
  final double? beforevalue;
  final String? message;

  const ReviewWriteState({this.review, this.isEditModel, this.beforevalue,this.status = CommonStatus.init,this.message});

  ReviewWriteState copyWith({
    Review? review,
    bool? isEditModel,
    double? beforevalue,
    CommonStatus? status,
    String? message,
  }) {
    return ReviewWriteState(
      review: review ?? this.review,
      isEditModel: isEditModel ?? this.isEditModel,
      beforevalue: beforevalue ?? this.beforevalue,
      status: status ?? this.status,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [review,isEditModel,beforevalue,status];
}
