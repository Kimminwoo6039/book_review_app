import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel extends Equatable {
  final String? uid;
  final String? name;
  final String? email;
  final String ? profile;
  final String ? discription;

  const UserModel({
    this.uid,
    this.name,
    this.email,
    this.profile,
    this.discription,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String,dynamic> toMap() =>_$UserModelToJson(this);

  UserModel copyWith({
    String? uid,
    String? name,
    String? email,
    String? profile,
    String? discription,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      name: name ?? this.name,
      profile: profile ?? this.profile,
      discription: discription ?? this.discription,
    );
  }

  @override
  List<Object?> get props => [
        uid,
        name,
        email,
    profile,
    discription,
      ];
}
