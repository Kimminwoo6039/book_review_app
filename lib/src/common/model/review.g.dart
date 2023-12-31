// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Review _$ReviewFromJson(Map<String, dynamic> json) => Review(
      bookId: json['bookId'] as String?,
      review: json['review'] as String?,
      value: (json['value'] as num?)?.toDouble(),
      naverBookInfo: json['naverBookInfo'] == null
          ? null
          : NaverBookInfo.fromJson(
              json['naverBookInfo'] as Map<String, dynamic>),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updateAt: json['updateAt'] == null
          ? null
          : DateTime.parse(json['updateAt'] as String),
      reviewerUid: json['reviewerUid'] as String?,
      likedUsers: (json['likedUsers'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$ReviewToJson(Review instance) => <String, dynamic>{
      'bookId': instance.bookId,
      'review': instance.review,
      'value': instance.value,
      'reviewerUid': instance.reviewerUid,
      'likedUsers': instance.likedUsers,
      'naverBookInfo': instance.naverBookInfo?.toJson(),
      'createdAt': instance.createdAt?.toIso8601String(),
      'updateAt': instance.updateAt?.toIso8601String(),
    };
