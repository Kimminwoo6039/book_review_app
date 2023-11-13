import 'package:book1/routers/route_path.dart';
import 'package:book1/src/common/cubit/app_data_load_cubit.dart';
import 'package:book1/src/common/cubit/authentication_cubit.dart';
import 'package:book1/src/common/repository/authentication_repository.dart';
import 'package:book1/src/common/repository/naver_api_reposiroty.dart';
import 'package:book1/src/common/repository/user_repository.dart';
import 'package:book1/src/init/cubit/init_cubit.dart';
import 'package:book1/src/init/page/init_page.dart';
import 'package:book1/src/login/page/login_page.dart';
import 'package:book1/src/root/page/root_page.dart';
import 'package:book1/src/splash/cubit/splash_cubit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

late final Dio dio;
late final db = FirebaseFirestore.instance;


final router = GoRouter(
  routes: [
    GoRoute(
      path: RoutePath.splash,
      name: "/splash",
      builder: (context, state) => MultiRepositoryProvider(
        providers: [
          BlocProvider(create: (context) => AppDataLoadCubit(), lazy: false),
          BlocProvider(
            create: (context) => SpalshCubit(),
          ),
          BlocProvider(
            create: (context) => InitCubit(),
          ),
          BlocProvider(
            create: (context) => AuthenticationCubit(context.read<AuthenticationRepository>(), context.read<UserRepository>()),
          ),
        ],
        child: MultiBlocProvider(
          providers: [
            RepositoryProvider(create: (context) => NaverBookRepostory(Dio()),),
            RepositoryProvider(create: (context) => AuthenticationRepository(FirebaseAuth.instance),),
            RepositoryProvider(create: (context) => UserRepository(FirebaseFirestore.instance),),
          ],
          child: const RootPage(),
        ),
      ),
    ),
    GoRoute(
      path: RoutePath.login,
      name: "/login",
      builder: (context, state) => MultiRepositoryProvider(
        providers: [
          BlocProvider(create: (context) => AppDataLoadCubit(), lazy: false),
          BlocProvider(
            create: (context) => SpalshCubit(),
          ),
          BlocProvider(
            create: (context) => InitCubit(),
          ),
          BlocProvider(
            create: (context) => AuthenticationCubit(context.read<AuthenticationRepository>(), context.read<UserRepository>()),
          ),
        ],
        child: MultiBlocProvider(
          providers: [
            RepositoryProvider(create: (context) => NaverBookRepostory(Dio()),),
            RepositoryProvider(create: (context) => AuthenticationRepository(FirebaseAuth.instance),),
            RepositoryProvider(create: (context) => UserRepository(FirebaseFirestore.instance),),
          ],
          child: const LoginPage(),
        ),
      ),
    )
  ],
  initialLocation: RoutePath.login,
);



