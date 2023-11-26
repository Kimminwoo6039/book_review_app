import 'package:book1/src/book_info/cubit/book_info_cubit.dart';
import 'package:book1/src/common/cubit/authentication_cubit.dart';
import 'package:book1/src/common/model/naver_book_info.dart';
import 'package:book1/src/common/repository/book_review_info_repository.dart';
import 'package:book1/src/common/repository/naver_api_reposiroty.dart';
import 'package:book1/src/common/repository/review_repository.dart';
import 'package:book1/src/common/repository/user_repository.dart';
import 'package:book1/src/home/page/home_page.dart';
import 'package:book1/src/review/detail/cubit/review_detail_cubit.dart';
import 'package:book1/src/review/detail/page/review_detail_page.dart';
import 'package:book1/src/review/write/cubit/review_write_cubit.dart';
import 'package:book1/src/review/write/page/review_write_page.dart';
import 'package:book1/src/root/page/root_page.dart';
import 'package:book1/src/search/cubit/search_book_cubit.dart';
import 'package:book1/src/search/page/search_page.dart';
import 'package:book1/src/signup/cubit/signup_cubit.dart';
import 'package:book1/src/signup/page/signup_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'book_info/page/book_info.dart';
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
    print("시작");
    super.initState();
    router = GoRouter(
      initialLocation: '/',
      refreshListenable: context.read<AuthenticationCubit>(),
      redirect: (context, state) {
        /// TODO : 진입
        var authStatus = context.read<AuthenticationCubit>().state.status;
        var blockPageInAuthenticationState = ['/', '/login', '/signup'];
        print(state.matchedLocation);
        switch (authStatus) {
          case AuthenticationStatus.authentication: // 인증이 됨 회원가입상태되고 로그인
            return blockPageInAuthenticationState
                    .contains(state.matchedLocation)
                ? '/home'
                : state.matchedLocation;
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
        GoRoute(path: '/', builder: (context, state) => const RootPage()),
        GoRoute(
          path: '/login',
          builder: (context, state) => const LoginPage(),
        ),
        GoRoute(
          path: '/home',
          builder: (context, state) => const HomePage(),
        ),
        GoRoute(
          path: '/info',
          builder: (context, state) => BlocProvider(
              create: (context) => BookInfoCubit(
                    context.read<BookReviewInfoRepository>(),
                    context.read<AuthenticationCubit>().state.user!.uid!,
                    context.read<UserRepository>(),
                    (state.extra as NaverBookInfo).isbn,
                  ),
              child: BookInfoPage(state.extra as NaverBookInfo)),
        ),
        GoRoute(
          path: '/review',
          builder: (context, state) => BlocProvider(
              create: (context) {
                var naverBookInfo = state.extra as NaverBookInfo;
                var uid = context.read<AuthenticationCubit>().state.user!.uid!;
                return ReviewWriteCubit(
                    context.read<BookReviewInfoRepository>(),
                    context.read<ReviewRepository>(),
                    uid,
                    naverBookInfo);
              },
              child: ReviewWritePage(state.extra as NaverBookInfo)),
        ),
        GoRoute(
          path: '/search',
          builder: (context, state) => BlocProvider(
              create: (context) =>
                  SearchBookCubit(context.read<NaverBookRepostory>()),
              child: const SearchPage()),
        ),
        GoRoute(
          path: '/review-detail/:bookId/:uid',
          builder: (context, state) => BlocProvider(
              create: (context) => ReviewDetailCubit(
                    context.read<ReviewRepository>(),
                    context.read<UserRepository>(),
                    state.pathParameters['uid'] as String,
                    state.pathParameters['bookId'] as String,
                  ),
              child: ReviewDetailPage(state.extra as NaverBookInfo)),
        ),
        GoRoute(
          path: '/signup',
          builder: (context, state) => BlocProvider(
            create: (_) => SignupCubit(
                context.read<AuthenticationCubit>().state.user!,
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
      debugShowCheckedModeBanner: false,
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
