### Firebase CLi

```
    npm install -g flutter_tools
```

## 로그인 여부 확인

```
    firebase login:list
```

## 로그인

```
    firebase login
```

### flutter_core 설치

```
    flutter_core 꼭 설치
```

## 현재 파이어베이스 설치 현황`

```
    flutterfire configure
```
## Flutter 프로젝트 firebase 설정 및 연결

```
  dart pub global activate flutterfire_cli
```


### Error:Cannot fit requested classes in a single dex file

```
2-1. minSdkVersion 20 이하 "AndroidX를 사용하지 않는" 경우
build.gradle(app) 파일에서 multiDexEnable을 true로 설정해서 추가하고 multidex 서포트 라이브러리를 dependencies에 추가해야 합니다.
```


### 구글 폰트

```
    flutter pub add google_fonts
```


### 스토리지 사용

```
  HydratedBloc.storage = await HydratedStorage.build(storageDirectory: await getApplicationDocumentsDirectory());
  
  flutter pub add hydrated_bloc
  flutter pub add path_provider
```


