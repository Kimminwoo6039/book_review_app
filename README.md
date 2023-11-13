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

### SVG 사용

```
flutter pub add flutter_svg
```


### 구글 로그인

```
    flutter pub add google_sign_in
```

### 구글로그인 공식 홈페이지 파이어베이스

```
  https://firebase.flutter.dev/docs/auth/social/

```


### 애플로그인

```
flutter pub add sign_in_with_apple crypto
```

### 디버그 sha-1추출

```
https://modelmaker.tistory.com/entry/%EC%95%88%EB%93%9C%EB%A1%9C%EC%9D%B4%EB%93%9C-Debug-SHA-Key-%EC%B6%94%EC%B6%9C-%EB%B0%A9%EB%B2%95
```



### 구글로그인

```
	<key>REVERSED_CLIENT_ID</key>
	<string>com.googleusercontent.apps.460277249838-8gj05h9uoib7h35h52reqhrj130fda73</string>
	
	xcode > Runner > Info > 맨밑에 URL types > URLSCHEMS > sTRING 값 붙혀넣기
	
	에러 가나옴
	
	
	cd ios >> pod install
```
