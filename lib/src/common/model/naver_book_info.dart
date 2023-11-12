import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'naver_book_info.g.dart';

@JsonSerializable()
class NaverBookInfo extends Equatable {
  final String? title;
  final String? link;
  final String? image;
  final String? author;
  final String? discount;
  final String? publisher;
  final String? pubdate;
  final String? description;


  NaverBookInfo({
    this.title,
    this.link,
    this.image,
    this.publisher,
    this.pubdate,
    this.author,
    this.description,
    this.discount,
});

  factory NaverBookInfo.fromJson(Map<String,dynamic> json)=>_$NaverBookInfoFromJson(json);

  @override
  List<Object?> get props => [
    title,
    link,
    image,
    publisher,
    pubdate,
    author,
    description,
    discount
  ];

}