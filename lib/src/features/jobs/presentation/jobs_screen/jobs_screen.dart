import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hntd/src/constants/strings.dart';
import 'package:hntd/src/features/jobs/data/jobs_repository.dart';
import 'package:hntd/src/features/jobs/domain/job.dart';
import 'package:hntd/src/features/jobs/presentation/jobs_screen/jobs_screen_controller.dart';
import 'package:hntd/src/routing/app_router.dart';
import 'package:hntd/src/utils/async_value_ui.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class JobsScreen extends StatefulWidget {
  @override
  _JobsScreenState createState() => _JobsScreenState();
}

class _JobsScreenState extends State<JobsScreen> {
  bool _isOverlayVisible = false;
  OverlayEntry?
      overlayEntry; // Declare the OverlayEntry as an instance variable

  void showOverlay(BuildContext context) {
    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: kToolbarHeight - 10,
        right: 10,
        child: Container(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black87,
            ),
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('업데이트 완료!'),
                  backgroundColor: Colors.indigo,
                ),
              );
              new DefaultCacheManager().emptyCache();
            },
            child: Text('업데이트',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          ),
        ),
      ),
    );

    Overlay.of(context)?.insert(overlayEntry!);
  }

  void toggleOverlayVisibility() {
    setState(() {
      _isOverlayVisible = !_isOverlayVisible;

      if (!_isOverlayVisible && overlayEntry != null) {
        overlayEntry!.remove(); // Remove the overlay
        overlayEntry = null; // Set overlayEntry to null
      } else {
        showOverlay(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.flag_rounded),
        title: const Text(Strings.jobs),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              toggleOverlayVisibility(); // Toggle the overlay visibility
            },
          ),
        ],
        // actions: [
        //   IconButton(
        //     onPressed: () {
        //       ScaffoldMessenger.of(context).hideCurrentSnackBar();
        //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        //         content: Text('캐시 이미지를 삭제했습니다.'),
        //       ));
        //       new DefaultCacheManager().emptyCache();
        //     },
        //     icon: Icon(Icons.delete_forever)
        //   )
        // ]
      ),
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
          // color: Colors.white,
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
                imageUrl: MediaQuery.of(context).orientation ==
                        Orientation.portrait
                    ? "https://firebasestorage.googleapis.com/v0/b/hana0re.appspot.com/o/bgImages%2F${proclaim?.book}_${proclaim?.page}_port.png?alt=media&token=ff6539d2-2d7b-4ccc-95e4-b8412bb9e6d1"
                    : "https://firebasestorage.googleapis.com/v0/b/hana0re.appspot.com/o/bgImages%2F${proclaim?.book}_${proclaim?.page}_land.png?alt=media&token=ff6539d2-2d7b-4ccc-95e4-b8412bb9e6d1",
                placeholder: (context, url) => CircularProgressIndicator(),
                errorWidget: (context, url, error) => Icon(Icons.error),
                fit: MediaQuery.of(context).orientation == Orientation.landscape
                    ? BoxFit.fitHeight
                    : BoxFit.fitWidth,
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
