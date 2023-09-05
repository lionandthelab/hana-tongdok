import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:starter_architecture_flutter_firebase/src/features/authentication/presentation/auth_providers.dart';
import '../../../common_widgets/date_picker.dart';

class CustomProfileScreen extends ConsumerWidget {
  const CustomProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authProviders = ref.watch(authProvidersProvider);

    return
      ProfileScreen(
        appBar: AppBar(
          title: const Text('Profile'),
        ),
        custom: Column(

          children: [
            SizedBox(
              width: double.infinity,

              child: Card(
                shape:ContinuousRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(width: 1.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      new LinearPercentIndicator(

                        animation: true,
                        animationDuration: 1000,
                        lineHeight: 20.0,
                        leading: new Text(" 완성률 "),
                        percent: 0.2,
                        center: Text("20.0%"),
                        linearStrokeCap: LinearStrokeCap.butt,
                        progressColor: Colors.red,
                      ),

                      date_picker(),
                    ],
                  ),
                ),
                elevation: 4.0,
                color:Colors.cyanAccent.withOpacity(0.4),
              ),
            ),
            const SizedBox(height: 16),
            const SizedBox(height: 16),

          ],
        ),
        providers: authProviders,
      );
  }
}
