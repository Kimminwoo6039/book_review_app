import 'package:book1/firebase_options.dart';
import 'package:book1/routers/routers.dart';
import 'package:book1/src/app.dart';
import 'package:book1/src/common/interceptor/custom_interceptor.dart';
import 'package:book1/src/common/model/naver_book_search_option.dart';
import 'package:book1/src/common/repository/naver_api_reposiroty.dart';
import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
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
    return MaterialApp.router(
      routerConfig: router,
    );
  }
}
