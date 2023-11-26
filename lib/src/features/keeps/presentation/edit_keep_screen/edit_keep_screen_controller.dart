import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:starter_architecture_flutter_firebase/src/features/authentication/data/firebase_auth_repository.dart';
import 'package:starter_architecture_flutter_firebase/src/features/keeps/data/keeps_repository.dart';
import 'package:starter_architecture_flutter_firebase/src/features/keeps/domain/keep.dart';
import 'package:starter_architecture_flutter_firebase/src/features/keeps/presentation/edit_keep_screen/keep_submit_exception.dart';

part 'edit_keep_screen_controller.g.dart';

@riverpod
class EditKeepScreenController extends _$EditKeepScreenController {
  @override
  FutureOr<void> build() {
    //
  }

  Future<bool> submit(
      {KeepID? keepId,
      Keep? oldKeep,
      required String title,
      required String verse,
      required String note}) async {
    final currentUser = ref.read(authRepositoryProvider).currentUser;
    if (currentUser == null) {
      throw AssertionError('User can\'t be null');
    }
    // set loading state
    state = const AsyncLoading().copyWithPrevious(state);
    // check if name is already in use
    final repository = ref.read(keepsRepositoryProvider);
    final keeps = await repository.fetchKeeps(uid: currentUser.uid);
    final allLowerCaseIds = keeps.map((keep) => keep.id.toLowerCase()).toList();
    // it's ok to use the same name as the old keep
    if (oldKeep != null) {
      allLowerCaseIds.remove(oldKeep.id.toLowerCase());
    }
    // check if name is already used
    if (allLowerCaseIds.contains(keepId?.toLowerCase())) {
      state = AsyncError(KeepSubmitException(), StackTrace.current);
      return false;
    } else {
      // keep previously existed
      if (keepId != null) {
        final keep = Keep(id: keepId, title: title, verse: verse, note: note);
        state = await AsyncValue.guard(
          () => repository.updateKeep(uid: currentUser.uid, keep: keep),
        );
      } else {
        state = await AsyncValue.guard(
          () => repository.addKeep(
              uid: currentUser.uid, title: title, verse: verse, note: note),
        );
      }
      return state.hasError == false;
    }
  }
}
