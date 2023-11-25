import 'package:book1/src/common/enum/common_state_status.dart';
import 'package:book1/src/common/model/book_review_info.dart';
import 'package:book1/src/common/repository/book_review_info_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../common/model/user_model.dart';
import '../../common/repository/user_repository.dart';

class BookInfoCubit extends Cubit<BookInfoState> {
  final BookReviewInfoRepository bookReviewInfoRepository;
  final String? uid;
  final UserRepository userRepository;
  final String? bookId;

  BookInfoCubit(
      this.bookReviewInfoRepository, this.uid, this.userRepository, this.bookId)
      : super(BookInfoState()) {
    loadBookReviewInfo();
  }

  void refresh() async {
    loadBookReviewInfo();
  }

  loadBookReviewInfo() async {
    emit(state.copyWith(status: CommonStatus.loading));

    var data = await bookReviewInfoRepository.loadBookReviewInfo(bookId!);
    
    if (data != null) {
      // 리뷰 정보 있을대
      if (data.reviewerUids!.isEmpty) {
        return ;
      } else {
      var reviewrList = await userRepository.allUserInfos(data.reviewerUids ?? []);
        emit(state.copyWith(status: CommonStatus.loaded,bookReivewInfo: data,reviewrs: reviewrList));
      }
    } else {
      emit(state.copyWith(status: CommonStatus.loaded));
    }

}

}

class BookInfoState extends Equatable {
  final CommonStatus status;
  final BookReivewInfo? bookReivewInfo;
  final List<UserModel>? reviewrs;

  const BookInfoState({
    this.bookReivewInfo,
    this.reviewrs,
    this.status = CommonStatus.init,
});

  BookInfoState copyWith({
     BookReivewInfo? bookReivewInfo,
     List<UserModel>? reviewrs,
      CommonStatus? status,
}) {
    return BookInfoState(
      bookReivewInfo: bookReivewInfo ?? this.bookReivewInfo,
      reviewrs: reviewrs ?? this.reviewrs,
      status: status ?? this.status,
    );
}

  @override
  List<Object?> get props => [bookReivewInfo,reviewrs,status];
}
