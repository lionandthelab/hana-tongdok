import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:starter_architecture_flutter_firebase/src/features/keeps/data/keeps_repository.dart';
import 'package:starter_architecture_flutter_firebase/src/features/keeps/domain/keep.dart';
import 'package:starter_architecture_flutter_firebase/src/features/keeps/presentation/keeps_screen/keep_list_item.dart';
import 'package:starter_architecture_flutter_firebase/src/features/keeps/presentation/keeps_screen/keeps_list_controller.dart';
import 'package:starter_architecture_flutter_firebase/src/routing/app_router.dart';
import 'package:starter_architecture_flutter_firebase/src/utils/async_value_ui.dart';

class KeepsList extends ConsumerWidget {
  const KeepsList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AsyncValue>(
      keepsListControllerProvider,
      (_, state) => state.showAlertDialogOnError(context),
    );
    final keepsQuery = ref.watch(keepsQueryProvider);
      return FirestoreListView<Keep>(
        query: keepsQuery,
        emptyBuilder: (context) => const Center(child: Text('No data')),
        errorBuilder: (context, error, stackTrace) => Center(
          child: Text(error.toString()),
        ),
        loadingBuilder: (context) => const Center(
            child: SizedBox(child: CircularProgressIndicator())),
        itemBuilder: (context, doc) {
          final keep = doc.data();
          print("keep: ${keep?.title}_${keep?.verse}");

          return Dismissible(
                key: Key('keep-${keep.id}'),
                background: Container(color: Colors.red),
                direction: DismissDirection.endToStart,
                onDismissed: (direction) => ref
                    .read(keepsListControllerProvider.notifier)
                    .deleteKeep(keep.id),
                child: KeepListTile(
                  keep: keep,
                  // onTap: () => context.goNamed(
                  //   AppRoute.editKeep.name,
                  //   pathParameters: {'id': keep.id},
                  // ),
                  onTap: () => context.goNamed(
                    AppRoute.editKeep.name,
                    pathParameters: {},
                    queryParameters: {'title': keep.title, 'verse': keep.verse, 'note':keep.note, 'id': keep.id}
                  ),
              ));
        },
      );
  }
}

class KeepListTile extends StatelessWidget {
  const KeepListTile({Key? key, required this.keep, this.onTap})
      : super(key: key);
  final Keep keep;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        margin: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: InkWell(
          onTap: onTap,
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                keep.title,
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                keep.verse,
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            SizedBox(height: 16.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                keep.note,
                style: TextStyle(fontSize: 14.0, fontStyle: FontStyle.italic),
              ),
            ),
            SizedBox(height: 16.0),
          ],
          )
        ),
      ),
    );
  }
}
