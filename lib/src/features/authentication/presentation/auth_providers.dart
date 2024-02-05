import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:firebase_ui_auth/firebase_ui_auth.dart' as firebase_ui_auth;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_providers.g.dart';

@Riverpod(keepAlive: true)
List<
        firebase_ui_auth
        .AuthProvider<firebase_ui_auth.AuthListener, AuthCredential>>
    authProviders(AuthProvidersRef ref) {
  return [
    firebase_ui_auth.EmailAuthProvider(),
  ];
}
