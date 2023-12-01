
import 'package:book1/src/common/model/user_model.dart';
import 'package:book1/src/common/repository/authentication_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../repository/review_repository.dart';
import '../repository/user_repository.dart';

class AuthenticationCubit extends Cubit<AuthenticationState> with ChangeNotifier {
  final AuthenticationRepository _authenticationRepository;
  final UserRepository _userRepository;
  final ReviewRepository reviewRepository;
  AuthenticationCubit(this._authenticationRepository, this._userRepository,this.reviewRepository)
      : super(AuthenticationState());

  // 스플래시 에서 구독
  void init() {
    _authenticationRepository.user.listen((user) {
      _userStateChangedEvent(user);
    });
  }

  void _userStateChangedEvent(UserModel? user) async {
    if (user == null) {
      /// TODO : 로그아웃 상태
      emit(state.copyWith(status: AuthenticationStatus.unKnown));
    } else {
      var result = await _userRepository.findUserOne(user.uid!);

      if (result == null) {
        // 유저 정보 전달
        emit(state.copyWith(user: user,status: AuthenticationStatus.unAuthenticated));
      } else {
      /// TODO : 로그인 상태
        emit(
          state.copyWith(
            status: AuthenticationStatus.authentication,
            user: result,
          ),
        );
      }
      
      // Go_router 리다이렉트 호출
      // emit(state.copyWith(status: AuthenticationStatus.authentication));
    }
      notifyListeners();
  }

  void reloadAuth() {
    _userStateChangedEvent(state.user);
}

  void googleLogin() async {
    await _authenticationRepository.signInWithGoogle();
  }

  void appleLogin() async {
    await _authenticationRepository.signInWithApple();
  }

  void logout() async {
    _authenticationRepository.logout();
  }

  void deleteUser() async {
     _authenticationRepository.deleteID();
  }


  Future<void>? updateReviewCounts() async {
    var results = await reviewRepository.loadMyAllReviews(state.user!.uid!);
    await _userRepository.updateReviewCounts(state.user!.uid!,results.length);
}

  @override
  void onChange(Change<AuthenticationState> change) {
    super.onChange(change);
    print(change);
    init();
  }

}

enum AuthenticationStatus {
  init,
  authentication,
  unAuthenticated,
  unKnown,
  error,
}

class AuthenticationState extends Equatable {
  final AuthenticationStatus status;
  final UserModel? user;

  const AuthenticationState({
    this.status = AuthenticationStatus.init,
    this.user,
  });

  AuthenticationState copyWith({
    AuthenticationStatus? status,
    UserModel? user,
  }) {
    return AuthenticationState(
      status: status ?? this.status,
      user: user ?? this.user,
    );
  }

  @override
  List<Object?> get props => [user, status];
}
