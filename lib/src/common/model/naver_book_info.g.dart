// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'naver_book_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NaverBookInfo _$NaverBookInfoFromJson(Map<String, dynamic> json) =>
    NaverBookInfo(
      title: json['title'] as String?,
      link: json['link'] as String?,
      image: json['image'] as String?,
      publisher: json['publisher'] as String?,
      pubdate: json['pubdate'] as String?,
      author: json['author'] as String?,
      description: json['description'] as String?,
      discount: json['discount'] as String?,
    );

Map<String, dynamic> _$NaverBookInfoToJson(NaverBookInfo instance) =>
    <String, dynamic>{
      'title': instance.title,
      'link': instance.link,
      'image': instance.image,
      'author': instance.author,
      'discount': instance.discount,
      'publisher': instance.publisher,
      'pubdate': instance.pubdate,
      'description': instance.description,
    };
