import 'dart:core';

import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:starter_architecture_flutter_firebase/src/constants/app_sizes.dart';
import 'package:starter_architecture_flutter_firebase/src/features/authentication/data/firebase_auth_repository.dart';

import 'auth_providers.dart';

class CustomSignInScreen extends ConsumerWidget {
  const CustomSignInScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authProviders = ref.watch(authProvidersProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('로그인'),
      ),
      body:
          SignInScreen(
            providers: authProviders,

            footerBuilder: (context, action) => const SignInAnonymouslyFooter(),
          ),
      );
  }
}

class LogoSubtitle extends ConsumerWidget {
  const LogoSubtitle({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        SizedBox(height: 10,),
        Image(
          image: AssetImage('assets/images/logo.png'),
          width: 200,
          height: 200,
          fit: BoxFit.contain,
        ),
      ],
    );
  }
}

class LogoSubtitle1 extends ConsumerWidget {
  const LogoSubtitle1({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return         Image(
      image: AssetImage('assets/images/logo.png'),
      width: 200,
      height: 150,
      fit: BoxFit.fill,
    );
  }
}

class SignInAnonymouslyFooter extends ConsumerWidget {
  const SignInAnonymouslyFooter({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        gapH8,
        const Row(
          children: [
            Expanded(child: Divider()),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: Sizes.p8),
              child: Text('or'),
            ),
            Expanded(child: Divider()),
          ],
        ),
        TextButton(
          onPressed: () => ref.read(firebaseAuthProvider).signInAnonymously(),
          child: const Text('비회원으로 이용하기'),
        ),
      ],
    );
  }
}
