import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hntd/src/features/authentication/presentation/auth_providers.dart';
import 'package:hntd/src/features/read/data/read_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CustomProfileScreen extends ConsumerWidget {
  const CustomProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authProviders = ref.watch(authProvidersProvider);
    return ProfileScreenStatefulWidget(
      authProviders: authProviders,
    );
  }
}

class ProfileScreenStatefulWidget extends StatefulWidget {
  final List<AuthProvider> authProviders;

  ProfileScreenStatefulWidget({required this.authProviders});

  @override
  _ProfileScreenStatefulWidgetState createState() =>
      _ProfileScreenStatefulWidgetState();
}

class _ProfileScreenStatefulWidgetState
    extends State<ProfileScreenStatefulWidget> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final ReadRepository readRepository = new ReadRepository();

  Future<void> _submitAddDate(DateTime selectedDate) async {
    if (selectedDate != null) {
      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        final path = 'users/${user!.uid}/dates';
        readRepository.addDate(uid: user.uid, date: selectedDate.toString());
        print("selectedDate.toString(): ${selectedDate.toString()}");

        QuerySnapshot querySnapshot = await _firestore.collection(path).get();
        print("after addDate: $querySnapshot");
      }
    }
  }

  Future<void> resetAllDates() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final path = 'users/${user.uid}/dates';
      _firestore.collection(path).get().then((snapshot) {
        for (DocumentSnapshot ds in snapshot.docs) {
          ds.reference.delete();
        }
      });
    }

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('달력을 초기화했습니다.'),
        backgroundColor: Colors.indigo,
      ),
    );
  }

  void checkAllDates() {
    DateTime now = DateTime.now();
    DateTime date = DateTime(now.year, 1, 1);

    while (date.isBefore(now)) {
      _submitAddDate(date);
      date = date.add(Duration(days: 1));
    }

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('오늘 이전 달력을 모두 체크했습니다. 마지막까지 화이팅!'),
        backgroundColor: Colors.indigo,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ProfileScreen(
      appBar: AppBar(
        title: const Text('프로필'),
        actions: <Widget>[
          PopupMenuButton<int>(
            onSelected: (item) => onSelected(context, item),
            itemBuilder: (context) => [
              PopupMenuItem<int>(
                value: 0,
                child: Text('달력 일괄 체크'),
              ),
              PopupMenuItem<int>(
                value: 1,
                child: Text('달력 초기화'),
              ),
            ],
          ),
        ],
      ),
      providers: widget.authProviders,
    );
  }

  void onSelected(BuildContext context, int item) {
    switch (item) {
      case 0:
        checkAllDates();
        break;
      case 1:
        resetAllDates();
        break;
    }
  }
}
