import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hntd/src/common_widgets/async_value_widget.dart';
import 'package:hntd/src/constants/strings.dart';
import 'package:hntd/src/features/keeps/data/keeps_repository.dart';
import 'package:hntd/src/features/keeps/domain/keep.dart';
import 'package:hntd/src/features/keeps/presentation/keeps_screen/keeps_list.dart';
import 'package:hntd/src/routing/app_router.dart';

class KeepsScreen extends StatelessWidget {
  const KeepsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(Strings.keeps),
      ),
      body: const KeepsList(),
      // floatingActionButton: FloatingActionButton(
      //   child: const Icon(Icons.add, color: Colors.white),
      //   onPressed: () => context.goNamed(
      //     AppRoute.addEntry.name,
      //     pathParameters: {'id': keep.id},
      //     extra: keep,
      //   ),
      // ),
    );
  }
}
