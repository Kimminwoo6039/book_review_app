
import 'package:book1/src/common/cubit/authentication_cubit.dart';
import 'package:book1/src/common/enum/common_state_status.dart';
import 'package:book1/src/splash/cubit/splash_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../common/components/app_font.dart';
import '../../common/cubit/app_data_load_cubit.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AppDataLoadCubit, AppDataLoadState>(
      listenWhen: (previous, current) =>
      current.status == CommonStatus.loaded,
      listener: (context, state) {
        print("음");
        print(state.status);
        context.read<SpalshCubit>().changeLoadStatus(LoadStatus.auth_check);
        context.read<AuthenticationCubit>().init();
      },
      child: Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              'assets/images/splash_bg.png',
              fit: BoxFit.cover,
            ),
            Positioned(
              bottom: MediaQuery.of(context).padding.bottom,
              left: 0,
              right: 0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const AppFont(
                    '도서 리뷰 앱으로\n좋아하는 책을 찾아보세요.',
                    textAlign: TextAlign.center,
                    size: 28,
                    fontWeight: FontWeight.bold,
                  ),
                  const SizedBox(height: 20),
                  BlocBuilder<SpalshCubit, LoadStatus>(
                      builder: (context, state) {
                        return AppFont(
                          '${state.message} 중 입니다.',
                          textAlign: TextAlign.center,
                          size: 13,
                          color: const Color(0xff878787),
                        );
                      }),
                  const SizedBox(height: 20),
                  const Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 1,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            )
          ],
        ),
      ),
    );
      }
  }
