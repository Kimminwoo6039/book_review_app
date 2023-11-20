import 'package:book1/src/common/model/naver_book_info_results.dart';
import 'package:book1/src/common/model/naver_book_search_option.dart';
import 'package:dio/dio.dart';

class NaverBookRepostory {
  final Dio _dio;
  NaverBookRepostory(this._dio);

  Future<NaverBookInfoResults> searchBook(NaverBookSearchOption searchOption) async {
    var response = await _dio.get('/v1/search/book.json',queryParameters:
    searchOption.toMap());

    print(NaverBookInfoResults.fromJson(response.data));

    return NaverBookInfoResults.fromJson(response.data);
  }
}
