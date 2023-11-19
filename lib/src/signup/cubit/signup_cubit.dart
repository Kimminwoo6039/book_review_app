import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../common/model/user_model.dart';

class SignupCubit extends Cubit<SignupState> {
  SignupCubit(UserModel userModel) : super(SignupState(userModel: userModel));

  changeProfileImage(XFile? image) {
    if (image == null) return;

    var file = File(image.path);
    emit(state.copyWith(profileFile: file));
  }

  void changeNickName(String nickname) {
    emit(state.copyWith(nickname: nickname));
  }

  void changeDiscription(String discription) {
    emit(state.copyWith(discription: discription));
  }

  void updateProfileImageUrl(String url) {
    emit(
      state.copyWith(
        status: SigupStatus.loading,
        userModel: state.userModel!.copyWith(profile: url),
      ),
    );
  }

  void uploadPercent(String percent) {
    emit(
      state.copyWith(percent: percent),
    );
  }

  void save() {
    print(state);
    if (state.nickname == null || state.nickname == '') return;

    emit(state.copyWith(status: SigupStatus.loading));

    if (state.profileFile != null) {
      emit(state.copyWith(status: SigupStatus.uploading));
    } else {}

    print(state);
  }
}

enum SigupStatus {
  init,
  loading,
  uploading,
  success,
  fail,
}

class SignupState extends Equatable {
  final File? profileFile;
  final String? nickname;
  final String? discription;
  final String? percent;
  final SigupStatus status;
  final UserModel? userModel;

  const SignupState({
    this.profileFile,
    this.nickname,
    this.discription,
    this.status = SigupStatus.init,
    this.userModel,
    this.percent,
  });

  SignupState copyWith({
    File? profileFile,
    String? nickname,
    String? discription,
    SigupStatus? status,
    UserModel? userModel,
    String? percent,
  }) {
    return SignupState(
      profileFile: profileFile ?? this.profileFile,
      nickname: nickname ?? this.nickname,
      discription: discription ?? this.discription,
      status: status ?? this.status,
      userModel: userModel ?? this.userModel,
      percent: percent ?? this.percent,
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props =>
      [profileFile, nickname, discription, status, userModel, percent];
}
