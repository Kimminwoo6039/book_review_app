import 'package:book1/routers/route_path.dart';
import 'package:book1/src/common/cubit/app_data_load_cubit.dart';
import 'package:book1/src/init/cubit/init_cubit.dart';
import 'package:book1/src/init/page/init_page.dart';
import 'package:book1/src/root/page/root_page.dart';
import 'package:book1/src/splash/cubit/splash_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../src/splash/page/splash_page.dart';

final router = GoRouter(
  routes: [
    GoRoute(
      path: RoutePath.splash,
      name: "/splash",
      builder: (context, state) =>
          MultiBlocProvider(
            providers: [
              BlocProvider(
                  create: (context) => AppDataLoadCubit(), lazy: false),
              BlocProvider(create: (context) => SpalshCubit(),),
              BlocProvider(create: (context) => InitCubit(),),
            ],
            child: const RootPage(),
          ),
    ),
    GoRoute(
      path: RoutePath.init,
      name: "/init",
      builder: (context, state) => const InitPage(),
    )
  ],
  initialLocation: RoutePath.splash,
);
