import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hntd/src/common_widgets/async_value_widget.dart';
import 'package:hntd/src/features/keeps/data/keeps_repository.dart';
import 'package:hntd/src/features/keeps/domain/keep.dart';
import 'package:hntd/src/features/keeps/presentation/keeps_screen/keeps_list.dart';
import 'package:hntd/src/routing/app_router.dart';

class KeepsScreen extends ConsumerWidget {
  const KeepsScreen({super.key, required this.keepId});
  final KeepID keepId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final keepAsync = ref.watch(keepStreamProvider(keepId));
    return ScaffoldAsyncValueWidget<Keep>(
      value: keepAsync,
      data: (keep) => KeepsPageContents(keep: keep),
    );
  }
}

class KeepsPageContents extends StatelessWidget {
  const KeepsPageContents({super.key, required this.keep});
  final Keep keep;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(keep.title),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.white),
            onPressed: () => context.goNamed(
              AppRoute.editKeep.name,
              pathParameters: {'id': keep.id},
              extra: keep,
            ),
          ),
        ],
      ),
      body: KeepsList(keep: keep),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () => context.goNamed(
          AppRoute.addEntry.name,
          pathParameters: {'id': keep.id},
          extra: keep,
        ),
      ),
    );
  }
}
