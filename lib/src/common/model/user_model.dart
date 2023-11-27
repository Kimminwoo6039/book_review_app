import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel extends Equatable {
  final String? uid;
  final String? name;
  final String? email;
  final String? profile;
  final String? discription;
  final List<String>? followers;
  final List<String>? followings;
  final int? followersCount;
  final int? followingsCount;
  final int? reviewCount;

  const UserModel({
    this.uid,
    this.name,
    this.email,
    this.profile,
    this.discription,
    this.followers,
    this.followings,
    this.followersCount,
    this.followingsCount,
    this.reviewCount,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toMap() => _$UserModelToJson(this);

  UserModel copyWith({
    String? uid,
    String? name,
    String? email,
    String? profile,
    String? discription,
    List<String>? followers,
    List<String>? followings,
    int? followersCount,
    int? followingsCount,
    int? reviewCount,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      name: name ?? this.name,
      profile: profile ?? this.profile,
      discription: discription ?? this.discription,
      followers: followers ?? this.followers,
      followings: followings ?? this.followings,
      followersCount: followingsCount ?? this.followersCount,
      followingsCount: followingsCount ?? this.followingsCount,
      reviewCount: reviewCount ?? this.reviewCount,
    );
  }

  @override
  List<Object?> get props =>
      [uid, name, email, profile, discription, followers, followings,followersCount,followingsCount,reviewCount];
}
