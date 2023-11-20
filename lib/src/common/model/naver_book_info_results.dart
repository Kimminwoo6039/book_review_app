
import 'package:book1/src/common/model/naver_book_info.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'naver_book_info_results.g.dart';

@JsonSerializable()
class NaverBookInfoResults extends Equatable {

  final int? total;
  final int? start;
  final int? display;
  final List<NaverBookInfo>? items;

  const NaverBookInfoResults.init() : this(start: 1,display: 10,items: const []);

  const NaverBookInfoResults({
    this.total,
    this.start,
    this.display,
    this.items,
});

  NaverBookInfoResults copyWith({
     int? total,
     int? start,
     int? display,
     List<NaverBookInfo>? items,
}){
    return NaverBookInfoResults(
      total: total ?? this.total,
      start: start ?? this.start,
      display: display ?? this.display,
      items: [...this.items ?? [], ...items?? []], // 추가적으로 붙혀줌..
    );
}

  factory NaverBookInfoResults.fromJson(Map<String,dynamic> json) => _$NaverBookInfoResultsFromJson(json);

  @override
  List<Object?> get props => [total,start,display,items];
}