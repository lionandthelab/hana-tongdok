import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:starter_architecture_flutter_firebase/src/common_widgets/primary_button.dart';
import 'package:starter_architecture_flutter_firebase/src/common_widgets/responsive_center.dart';
import 'package:starter_architecture_flutter_firebase/src/constants/app_sizes.dart';
import 'package:starter_architecture_flutter_firebase/src/features/onboarding/presentation/onboarding_controller.dart';
import 'package:starter_architecture_flutter_firebase/src/localization/string_hardcoded.dart';
import 'package:starter_architecture_flutter_firebase/src/routing/app_router.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart' show CalendarCarousel;

class OnboardingScreen extends ConsumerWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(onboardingControllerProvider);
    return Scaffold(
      body: ResponsiveCenter(
        maxContentWidth: 450,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              '하나통독',
              style: Theme.of(context).textTheme.headlineLarge,
              textAlign: TextAlign.center,
            ),
            gapH16,
            Text(
              '말씀으로 하루를 시작하세요.',
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            gapH64,
            SvgPicture.asset(
              'assets/Open-Bible.svg',
              width: 200,
              height: 200,
              semanticsLabel: 'hntd logo',
            ),
            gapH64,
            
            // CalendarCarousel(
            //   // current: DateTime.now(),
            //   // onDayPressed: (DateTime date) {
            //   //   this.setState(() => _currentDate = date);
            //   // },
            //   thisMonthDayBorderColor: Colors.grey,
            //   height: 420.0,
            //   // selectedDateTime: _currentDate,
            //   daysHaveCircularBorder: null, /// null for not rendering any border, true for circular border, false for rectangular border
            //   // markedDatesMap: _markedDateMap,
            //   headerTextStyle: TextStyle(
            //     color: Colors.cyan,
            //   ),
            //   weekdayTextStyle: TextStyle(
            //     color: Colors.cyan,
            //   ),
            //   weekendTextStyle: TextStyle(
            //     color: Colors.cyan,
            //   ),
            //   // weekDays: null, /// for pass null when you do not want to render weekDays
            // ),
            PrimaryButton(
              text: '시작하기'.hardcoded,
              isLoading: state.isLoading,
              onPressed: state.isLoading
                  ? null
                  : () async {
                      await ref
                          .read(onboardingControllerProvider.notifier)
                          .completeOnboarding();
                      if (context.mounted) {
                        // go to sign in page after completing onboarding
                        context.goNamed(AppRoute.signIn.name);
                      }
                    },
            ),
          ],
        ),
      ),
    );
  }
}
