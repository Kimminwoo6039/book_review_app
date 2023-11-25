import 'package:book1/src/common/model/naver_book_info.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'book_review_info.g.dart';

@JsonSerializable(explicitToJson : true)
class BookReivewInfo extends Equatable {
  final NaverBookInfo? naverBookInfo;
  final DateTime? createAt;
  final DateTime? updateAt;
  final String? bookId;
  final double? totalCount;
  final List<String>? reviewerUids;


   const BookReivewInfo({
     this.naverBookInfo,
     this.updateAt,
     this.createAt,
     this.bookId,
     this.totalCount,
     this.reviewerUids
});

   factory BookReivewInfo.fromJson(Map<String,dynamic> json) => _$BookReivewInfoFromJson(json);

   Map<String,dynamic> toJson() => _$BookReivewInfoToJson(this);

   BookReivewInfo copyWith({
      NaverBookInfo? naverBookInfo,
      DateTime? createAt,
      DateTime? updateAt,
      String? bookId,
      double? totalCount,
      List<String>? reviewerUids,
}) {
     return BookReivewInfo(
       naverBookInfo: naverBookInfo ?? this.naverBookInfo,
       updateAt: updateAt ?? this.updateAt,
       bookId: bookId ?? this.bookId,
       createAt: createAt ?? this.createAt,
       reviewerUids: reviewerUids ?? this.reviewerUids,
       totalCount: totalCount ?? this.totalCount,
     );
}

  @override
  List<Object?> get props => [
    naverBookInfo,
    updateAt,
    createAt,
    bookId,
    totalCount,
    reviewerUids
  ];

}