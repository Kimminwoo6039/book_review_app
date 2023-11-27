import 'package:book1/src/common/model/book_review_info.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../common/repository/book_review_info_repository.dart';

class RecentlyCubit extends Cubit<RecentlyState> {
  BookReviewInfoRepository bookReviewInfoRepository;
  RecentlyCubit(this.bookReviewInfoRepository) : super(RecentlyState()) {
    _loadBookReviewInfos();
  }

  _loadBookReviewInfos() async {
    var result = await bookReviewInfoRepository.loadBookReviewRecentlyData();
    emit(state.copyWith(result: result));
  }

 void refresh() async {
   await _loadBookReviewInfos();
}
}

class RecentlyState extends Equatable {
  final List<BookReivewInfo>? result;
  const RecentlyState({this.result});

  RecentlyState copyWith({
    List<BookReivewInfo>? result,
}) {
    return RecentlyState(result: result ?? this.result);
}
  @override
  List<Object?> get props => [result];

}