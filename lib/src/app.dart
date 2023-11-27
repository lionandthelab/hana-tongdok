import 'package:flutter/material.dart';

import 'package:firebase_ui_localizations/firebase_ui_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:starter_architecture_flutter_firebase/src/routing/app_router.dart';

import 'package:intl/intl.dart';

class LabelOverrides extends DefaultLocalizations {
  const LabelOverrides();

  @override
  String get emailInputLabel => 'E-mail';
  @override
  String get passwordInputLabel => '비밀번호';
  @override
  String get signInActionText => '로그인';
  @override
  String get registerText => '회원가입';
  @override
  String get registerHintText => '회원이 아니신가요? ';
  @override
  String get signInText => '로그인';
  @override
  String get forgotPasswordButtonLabel => '비밀번호 찾기';
  @override
  String get forgotPasswordViewTitle => '비밀번호 찾기';
  @override
  String get resetPasswordButtonLabel => '비밀번호 재설정';
  @override
  String get forgotPasswordHintText =>
      '하나통독 회원가입시 입력했던 이메일을 입력해주세요. \n등록된 이메일로 비밀번호 재설정 링크를 보내드립니다.';
  @override
  String get goBackButtonLabel => '뒤로가기';
  @override
  String get confirmPasswordInputLabel => '비밀번호 확인';
  @override
  String get registerActionText => '회원가입';
  @override
  String get signInHintText => '이미 계정이 있으신가요? ';
  @override
  String get emailIsRequiredErrorText => '올바른 이메일이 아닙니다 ';
  @override
  String get passwordIsRequiredErrorText => '적절한 비밀번호가 아닙니다 ';
  @override
  String get confirmPasswordDoesNotMatchErrorText => '비밀번호가 일치하지 않습니다';
  @override
  String get wrongOrNoPasswordErrorText => '잘못된 비밀번호 입니다';
  @override
  String get confirmPasswordIsRequiredErrorText => '적절한 비밀번호가 아닙니다';
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goRouter = ref.watch(goRouterProvider);

    return MaterialApp.router(
      routerConfig: goRouter,
      theme: ThemeData(
        fontFamily: 'NotoSansKR',
        fontFamilyFallback: <String>['NotoSansEN'],
        primarySwatch: Colors.indigo,
        unselectedWidgetColor: Colors.grey,
        appBarTheme: const AppBarTheme(
          elevation: 2.0,
          centerTitle: true,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          iconTheme: IconThemeData(color: Colors.black),
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        scaffoldBackgroundColor: Colors.grey[200],
        dividerColor: Colors.grey[400],
        // https://github.com/firebase/flutterfire/blob/master/packages/firebase_ui_auth/doc/theming.md
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Colors.indigo),
            foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
      supportedLocales: const [
        Locale('en', 'US'), // 영어 (미국)
        Locale('ko', 'KR'), // 한국어 (대한민국)
        // 다른 지원하는 로케일들을 추가할 수 있습니다.
      ],
      localizationsDelegates: [
        FirebaseUILocalizations.withDefaultOverrides(const LabelOverrides()),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        FirebaseUILocalizations.delegate,
      ],
    );
  }
}
