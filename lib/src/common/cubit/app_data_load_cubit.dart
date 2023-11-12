import 'package:book1/src/common/enum/common_state_status.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppDataLoadCubit extends Cubit<AppDataLoadState> {
  AppDataLoadCubit() : super(AppDataLoadState()) {
    _loadData();
  }

  void _loadData() async {

    emit(state.copyWith(status: CommonStatus.loading));

    await Future.delayed(const Duration(milliseconds: 10));

    emit(state.copyWith(status: CommonStatus.loaded));

    print("값변경");
  }
}

class AppDataLoadState extends Equatable {
  final CommonStatus status;
  AppDataLoadState({this.status = CommonStatus.init});

  AppDataLoadState copyWith({
    CommonStatus? status,
}) {
    return AppDataLoadState(status: status ?? this.status);
  }

  @override
  List<Object?> get props => [status];

}