import 'package:book1/src/common/enum/common_state_status.dart';
import 'package:book1/src/common/model/naver_book_search_option.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../common/model/naver_book_info_results.dart';
import '../../common/repository/naver_api_reposiroty.dart';

class SearchBookCubit extends Cubit<SearchBookState> {
  final NaverBookRepostory _naverBookRepostory;

  SearchBookCubit(this._naverBookRepostory) : super(SearchBookState());

  void search(String searchKey) async {
    emit(state.copyWith(
        status: CommonStatus.loading,
        results: const NaverBookInfoResults.init(),
        searchOption: state.searchOption!.copyWith(query: searchKey)));
    // var searchOption = NaverBookSearchOption(
    //   query: searchKey,
    //   display: 10,
    //   start: 1,
    //   sort: NaverBookSearchType.date,
    // );
    _searchToNaverApi();
  }

  void _searchToNaverApi () async {
    var result = await _naverBookRepostory.searchBook(state.searchOption!);

    // 더이상 호출할 값이 없을때 마지막페이지
    if (result.start! > result.total! || result.items!.isEmpty!) {
      emit(state.copyWith(status: CommonStatus.complate));
    } else {
      emit(state.copyWith(
          status: CommonStatus.loaded,
          results: state.results!.copyWith(items: result.items)));
    }
  }

  void nextPage() {
    emit(state.copyWith(
        status: CommonStatus.loaded,
        searchOption: state.searchOption!.copyWith(
            start: state.searchOption!.start! + state.searchOption!.display!)));

    _searchToNaverApi();
  }
}

class SearchBookState extends Equatable {
  final CommonStatus status;
  final NaverBookInfoResults? results;
  final NaverBookSearchOption? searchOption;

  const SearchBookState({
    this.status = CommonStatus.init,
    this.results = const NaverBookInfoResults.init(),
    this.searchOption = const NaverBookSearchOption.init(query: ''),
  });

  SearchBookState copyWith({
    CommonStatus? status,
    NaverBookInfoResults? results,
    NaverBookSearchOption? searchOption,
  }) {
    return SearchBookState(
        status: status ?? this.status,
        results: results ?? this.results,
        searchOption: searchOption ?? this.searchOption);
  }

  @override
  List<Object?> get props => [status, results, searchOption];
}
