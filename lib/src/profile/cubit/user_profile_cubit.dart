import 'package:book1/src/common/enum/common_state_status.dart';
import 'package:book1/src/common/repository/user_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../common/model/user_model.dart';

class UserProfileCubit extends Cubit<UserProfileState> {
  final UserRepository userRepository;
  final String uid;

  UserProfileCubit(this.uid, this.userRepository) : super(UserProfileState()) {
    _loadUserProfile();
  }

  void _loadUserProfile() async {
    emit(state.copyWith(status: CommonStatus.loading));
    var userInfo = await userRepository.findUserOne(uid);
    if (userInfo == null) {
      emit(state.copyWith(status: CommonStatus.error));
    } else {
      emit(state.copyWith(userModel: userInfo, status: CommonStatus.loaded));
    }
  }

  void followToggleEvent(String myUid) async {
    if (state.userModel!.followers != null &&
        state.userModel!.followers!.contains(myUid)) {
      // 즐겨찾기 취소 언팔
      var result = await userRepository.followEvent(false,state.userModel!.uid!,myUid);
      if (result) {
        await _unfollow(myUid);
      }

    } else {
      // 즐겨 찾기 하기
      var result = await userRepository.followEvent(true,state.userModel!.uid!, myUid);
      if (result) {
        await  _follow(myUid);
      }
    }
  }

  _unfollow(myUid) async {
    emit(
     await state.copyWith(
        userModel: state.userModel!.copyWith(
          followers: List.unmodifiable(
            [...state.userModel!.followers!.where((targetUid) => targetUid != myUid)],
          ),
        ),
      ),
    );
  }

  _follow(myUid) async {
    print(state.userModel!.followers);
    if (state.userModel!.followers == null) {
      // 최초 팔로워 대상
      emit(
        await state.copyWith(
          userModel: state.userModel!.copyWith(
            followers: List.unmodifiable(
              [myUid],
            ),
          ),
        ),
      );
    } else {
      // 다른사람이 이미 팔로워 한사람
      emit(
        await state.copyWith(
          userModel: state.userModel!.copyWith(
            followers: List.unmodifiable(
              [
                ...state.userModel!.followers!,
                uid
              ],
            ),
          ),
        ),
      );
    }
  }
}

class UserProfileState extends Equatable {
  final CommonStatus status;
  final UserModel? userModel;

  const UserProfileState({this.userModel, this.status = CommonStatus.init});

  UserProfileState copyWith({
    UserModel? userModel,
    CommonStatus? status,
  }) {
    return UserProfileState(
        userModel: userModel ?? this.userModel, status: status ?? this.status);
  }

  @override
  List<Object?> get props => [userModel, status];
}
