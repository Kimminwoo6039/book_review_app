// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'book_review_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BookReivewInfo _$BookReivewInfoFromJson(Map<String, dynamic> json) =>
    BookReivewInfo(
      naverBookInfo: json['naverBookInfo'] == null
          ? null
          : NaverBookInfo.fromJson(
              json['naverBookInfo'] as Map<String, dynamic>),
      updateAt: json['updateAt'] == null
          ? null
          : DateTime.parse(json['updateAt'] as String),
      createAt: json['createAt'] == null
          ? null
          : DateTime.parse(json['createAt'] as String),
      bookId: json['bookId'] as String?,
      totalCount: (json['totalCount'] as num?)?.toDouble(),
      reviewerUids: (json['reviewerUids'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$BookReivewInfoToJson(BookReivewInfo instance) =>
    <String, dynamic>{
      'naverBookInfo': instance.naverBookInfo?.toJson(),
      'createAt': instance.createAt?.toIso8601String(),
      'updateAt': instance.updateAt?.toIso8601String(),
      'bookId': instance.bookId,
      'totalCount': instance.totalCount,
      'reviewerUids': instance.reviewerUids,
    };
