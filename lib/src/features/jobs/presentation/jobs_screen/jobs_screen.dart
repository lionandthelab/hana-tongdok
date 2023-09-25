import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:starter_architecture_flutter_firebase/src/constants/strings.dart';
import 'package:starter_architecture_flutter_firebase/src/features/jobs/data/jobs_repository.dart';
import 'package:starter_architecture_flutter_firebase/src/features/jobs/domain/job.dart';
import 'package:starter_architecture_flutter_firebase/src/features/jobs/presentation/jobs_screen/jobs_screen_controller.dart';
import 'package:starter_architecture_flutter_firebase/src/routing/app_router.dart';
import 'package:starter_architecture_flutter_firebase/src/utils/async_value_ui.dart';
import 'package:cached_network_image/cached_network_image.dart';

class JobsScreen extends StatelessWidget {
  const JobsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MediaQuery.of(context).orientation == Orientation.portrait ? AppBar(        
        title: const Text(Strings.jobs),
        // actions: <Widget>[
        //   IconButton(
        //     icon: const Icon(Icons.add, color: Colors.white),
        //     onPressed: () => context.goNamed(AppRoute.addJob.name),
        //   ),
        // ],
      ): null,
      body: Consumer(
        builder: (context, ref, child) {
          ref.listen<AsyncValue>(
            jobsScreenControllerProvider,
            (_, state) => state.showAlertDialogOnError(context),
          );
          final proclaimsQuery = ref.watch(jobsQueryProvider);
          return FirestoreListView<Job>(
            query: proclaimsQuery,
            emptyBuilder: (context) => const Center(child: Text('No data')),
            errorBuilder: (context, error, stackTrace) => Center(
              child: Text(error.toString()),
            ),
            loadingBuilder: (context) =>
                const Center(child: CircularProgressIndicator()),
            itemBuilder: (context, doc) {
              final proclaim = doc.data();
              print("proclaim: ${proclaim?.book}_${proclaim?.page}");

              return ProclaimListTile(
                proclaim: proclaim,
                onTap: () => context.goNamed(
                  AppRoute.job.name,
                  pathParameters: {'id': proclaim.id},
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class ProclaimListTile extends StatelessWidget {
  const ProclaimListTile({Key? key, required this.proclaim, this.onTap})
      : super(key: key);
  final Job proclaim;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CachedNetworkImage(
              width: MediaQuery.of(context).orientation == Orientation.portrait ?
           null: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).orientation == Orientation.portrait ?
           MediaQuery.of(context).size.height * 0.8: null,
                imageUrl: MediaQuery.of(context).orientation == Orientation.portrait ?
                    "https://firebasestorage.googleapis.com/v0/b/hana0re.appspot.com/o/bgImages%2F${proclaim?.book}_${proclaim?.page}_port.png?alt=media&token=ff6539d2-2d7b-4ccc-95e4-b8412bb9e6d1":
                    "https://firebasestorage.googleapis.com/v0/b/hana0re.appspot.com/o/bgImages%2F${proclaim?.book}_${proclaim?.page}_land.png?alt=media&token=ff6539d2-2d7b-4ccc-95e4-b8412bb9e6d1",
                placeholder: (context, url) => CircularProgressIndicator(),
                errorWidget: (context, url, error) => Icon(Icons.error),
                fit: MediaQuery.of(context).orientation == Orientation.landscape ? BoxFit.fitHeight: BoxFit.fitWidth,
                alignment: Alignment.center),
            // Padding(
            //   padding: const EdgeInsets.all(16.0),
            //   child: Text(
            //     'Card Title',
            //     style: TextStyle(
            //       fontSize: 24.0,
            //       fontWeight: FontWeight.bold,
            //     ),
            //   ),
            // ),
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 16.0),
            //   child: Text(
            //     'This is a beautiful card with some description text. You can customize it as needed.',
            //     style: TextStyle(fontSize: 16.0),
            //   ),
            // ),
            SizedBox(height: 16.0),
          ],
        ),
      ),
    );
    // return Padding(
    //     padding: const EdgeInsets.all(16.0),
    //     child: Card(
    //       elevation: 10.0,
    //       shape: Border(
    //         borderRadius: BorderRadius.circular(15.0),
    //       ),
    //       child: Center(
    //           child: CachedNetworkImage(
    //         imageUrl:
    //             "https://firebasestorage.googleapis.com/v0/b/hana0re.appspot.com/o/bgImages%2F${proclaim?.book}_${proclaim?.page}_port.png?alt=media&token=ff6539d2-2d7b-4ccc-95e4-b8412bb9e6d1",
    //         placeholder: (context, url) => CircularProgressIndicator(),
    //         errorWidget: (context, url, error) => Icon(Icons.error),
    //         fit: BoxFit.fitWidth,
    //         alignment: Alignment.center,
    //       )),
    //     ));

    // return ListTile(
    //   title: Text(job.name),
    //   trailing: const Icon(Icons.chevron_right),
    //   onTap: onTap,
    // );
  }
}
