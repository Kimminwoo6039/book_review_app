import 'package:book1/src/common/model/naver_book_info.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'review.g.dart';

// explicitToJson = true 이면 g.dart to json 컨버터 해줌
@JsonSerializable(explicitToJson: true)
class Review extends Equatable {
  final String? bookId;
  final String? review;
  final double? value;
  final String? reviewerUid;
  final NaverBookInfo? naverBookInfo;
  final DateTime? createdAt;
  final DateTime? updateAt;

  const Review({
    this.bookId,
    this.review,
    this.value,
    this.naverBookInfo,
    this.createdAt,
    this.updateAt,
    this.reviewerUid
  });

  factory Review.fromJson(Map<String, dynamic> json) => _$ReviewFromJson(json);

  // NaverBookInfo 오브젝트니깐.. to json 넣어줘야함..
  Map<String, dynamic> toJson() => _$ReviewToJson(this);


  Review copyWith({
    String? bookId,
    String? review,
    double? value,
    String? reviewerUid,
    NaverBookInfo? naverBookInfo,
    DateTime? createdAt,
    DateTime? updateAt,
  }) {
    return Review(
      review: review ?? this.review,
      bookId: bookId ?? this.bookId,
      createdAt: createdAt ?? this.createdAt,
      naverBookInfo: naverBookInfo ?? this.naverBookInfo,
      reviewerUid: reviewerUid ?? this.reviewerUid,
      updateAt: updateAt ?? this.updateAt,
      value: value ?? this.value,
    );
  }


  @override
  List<Object?> get props =>
      [review, value, naverBookInfo, createdAt, updateAt, bookId, reviewerUid];
}
