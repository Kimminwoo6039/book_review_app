import 'package:book1/src/common/cubit/authentication_cubit.dart';
import 'package:book1/src/common/repository/user_repository.dart';
import 'package:book1/src/home/page/home_page.dart';
import 'package:book1/src/root/page/root_page.dart';
import 'package:book1/src/signup/cubit/signup_cubit.dart';
import 'package:book1/src/signup/page/signup_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'login/page/login_page.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late GoRouter router;

  @override
  void initState() {
    super.initState();
    router = GoRouter(
      initialLocation: '/',
      refreshListenable: context.read<AuthenticationCubit>(),
      redirect: (context, state) {
        /// TODO : 진입
        var authStatus = context.read<AuthenticationCubit>().state.status;
        switch (authStatus) {
          case AuthenticationStatus.authentication: // 인증이 됨 회원가입상태되고 로그인
            return '/home';
            break;
          case AuthenticationStatus.unAuthenticated:
            return '/signup';
          case AuthenticationStatus.unKnown:
            return '/login';
          case AuthenticationStatus.init:
            break;
          case AuthenticationStatus.error:
            break;
        }
        return state.path;
      },
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const RootPage(),
        ),
        GoRoute(
          path: '/login',
          builder: (context, state) => const LoginPage(),
        ),
        GoRoute(
          path: '/home',
          builder: (context, state) => const HomePage(),
        ),
        GoRoute(
          path: '/signup',
          builder: (context, state) => BlocProvider(
            create: (_) => SignupCubit(context.read<AuthenticationCubit>().state.user!,
            context.read<UserRepository>()),
            child: const SignupPage(),
          ),
        ),
      ],
    );
    //route
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: router,
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          elevation: 0,
          backgroundColor: const Color(0xff1C1C1C),
          titleTextStyle: TextStyle(color: Colors.white),
        ),
        scaffoldBackgroundColor: const Color(0xff1C1C1C),
      ),
    );
  }
}
