import 'package:book1/src/init/cubit/init_cubit.dart';
import 'package:book1/src/init/page/init_page.dart';
import 'package:book1/src/splash/page/splash_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../common/cubit/app_data_load_cubit.dart';

/// TODO : 최초 실행여부로 인한 , 스플래쉬 도는 인잇 페이지
class RootPage extends StatelessWidget {
  const RootPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InitCubit, bool>(
      builder: (context, state) {
        return state //*********** 이부분을 수정해주시면 됩니다.
            ? BlocProvider(
                create: (context) => AppDataLoadCubit(),
                child: const SplashPage(),
              )
            : InitPage();
//***********
      },
    );
  }
}
