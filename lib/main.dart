import 'package:book1/firebase_options.dart';
import 'package:book1/routers/routers.dart';
import 'package:book1/src/app.dart';
import 'package:book1/src/common/cubit/app_data_load_cubit.dart';
import 'package:book1/src/common/cubit/authentication_cubit.dart';
import 'package:book1/src/common/cubit/upload_cubit.dart';
import 'package:book1/src/common/interceptor/custom_interceptor.dart';
import 'package:book1/src/common/model/naver_book_search_option.dart';
import 'package:book1/src/common/repository/authentication_repository.dart';
import 'package:book1/src/common/repository/naver_api_reposiroty.dart';
import 'package:book1/src/common/repository/user_repository.dart';
import 'package:book1/src/init/cubit/init_cubit.dart';
import 'package:book1/src/splash/cubit/splash_cubit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  /// TODO : 파이어베이스 SDK  안드로이드,IOS 상호작용 초기화
  WidgetsFlutterBinding.ensureInitialized();
  /// TODO : 현재 진행하는 플랫폼
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: await getApplicationDocumentsDirectory()
  );

  Dio dio = Dio(BaseOptions(baseUrl: 'https://openapi.naver.com/'));
  dio.interceptors.add(CustomInterCeptor()); // 인터셉터 넣어주넉 적용
  runApp(MyApp(dio: dio));
}

class MyApp extends StatelessWidget {
  final Dio dio;

  const MyApp({super.key, required this.dio});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    var db = FirebaseFirestore.instance;
    var storage = FirebaseStorage.instance;
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) => NaverBookRepostory(dio),
        ),
        RepositoryProvider(
          create: (context) => AuthenticationRepository(FirebaseAuth.instance),
        ),
        RepositoryProvider(
          create: (context) => UserRepository(db),
        ),
        // RepositoryProvider(
        //   create: (context) => BookReviewInfoRepository(db),
        // ),
        // RepositoryProvider(
        //   create: (context) => ReviewRepository(db),
        // )
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => InitCubit(),
            lazy: false,
          ),
          BlocProvider(
            create: (context) => AppDataLoadCubit(),
            lazy: false,
          ),
          BlocProvider(create: (context) => UploadCubit(storage)),
          BlocProvider(create: (context) => SpalshCubit()),
          BlocProvider(
            create: (context) => AuthenticationCubit(
              context.read<AuthenticationRepository>(),
              context.read<UserRepository>(),
              // context.read<ReviewRepository>(),
            ),
          )
        ],
        child: const App(),
      ),
    );
  }
}
