import 'dart:math';

import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:hntd/src/features/authentication/data/firebase_auth_repository.dart';
import 'package:hntd/src/features/authentication/presentation/custom_profile_screen.dart';
import 'package:hntd/src/features/authentication/presentation/custom_sign_in_screen.dart';
import 'package:hntd/src/features/entries/presentation/entries_screen.dart';
import 'package:hntd/src/features/entries/domain/entry.dart';
import 'package:hntd/src/features/jobs/domain/job.dart';
import 'package:hntd/src/features/entries/presentation/entry_screen/entry_screen.dart';
import 'package:hntd/src/features/jobs/presentation/job_entries_screen/job_entries_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:hntd/src/features/jobs/presentation/edit_job_screen/edit_job_screen.dart';
import 'package:hntd/src/features/jobs/presentation/jobs_screen/jobs_screen.dart';
import 'package:hntd/src/features/keeps/domain/keep.dart';
import 'package:hntd/src/features/keeps/presentation/edit_keep_screen/edit_keep_screen.dart';
import 'package:hntd/src/features/keeps/presentation/keeps_screen/keeps_screen.dart';
import 'package:hntd/src/features/onboarding/data/onboarding_repository.dart';
import 'package:hntd/src/features/onboarding/presentation/onboarding_screen.dart';
import 'package:hntd/src/features/read/presentation/read_screen.dart';
import 'package:hntd/src/routing/go_router_refresh_stream.dart';
import 'package:hntd/src/routing/scaffold_with_nested_navigation.dart';

part 'app_router.g.dart';

// private navigators
final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _readNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'read');
final _jobsNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'proclaim');
final _entriesNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'entries');
final _accountNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'account');

enum AppRoute {
  onboarding,
  signIn,
  jobs,
  job,
  addJob,
  editJob,
  entry,
  addEntry,
  editEntry,
  entries,
  profile,
  read,
  keep,
  addKeep,
  editKeep,
}

@riverpod
// ignore: unsupported_provider_value
GoRouter goRouter(GoRouterRef ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  final onboardingRepository = ref.watch(onboardingRepositoryProvider);
  return GoRouter(
    initialLocation: '/onboarding',
    navigatorKey: _rootNavigatorKey,
    debugLogDiagnostics: true,
    redirect: (context, state) {
      final didCompleteOnboarding = onboardingRepository.isOnboardingComplete();
      if (!didCompleteOnboarding) {
        // Always check state.subloc before returning a non-null route
        // https://github.com/flutter/packages/blob/main/packages/go_router/example/lib/redirection.dart#L78
        if (state.location != '/onboarding') {
          return '/onboarding';
        }
      }
      final isLoggedIn = authRepository.currentUser != null;
      if (isLoggedIn) {
        if (state.location.startsWith('/signIn')) {
          return '/read';
        }
      } else {
        if (state.location.startsWith('/read') ||
            state.location.startsWith('/proclaim') ||
            // state.location.startsWith('/entries') ||
            state.location.startsWith('/account')) {
          return '/signIn';
        }
      }
      return null;
    },
    refreshListenable: GoRouterRefreshStream(authRepository.authStateChanges()),
    routes: [
      GoRoute(
        path: '/onboarding',
        name: AppRoute.onboarding.name,
        pageBuilder: (context, state) => const NoTransitionPage(
          child: OnboardingScreen(),
        ),
      ),
      GoRoute(
        path: '/signIn',
        name: AppRoute.signIn.name,
        pageBuilder: (context, state) => const NoTransitionPage(
          child: CustomSignInScreen(),
        ),
      ),
      // Stateful navigation based on:
      // https://github.com/flutter/packages/blob/main/packages/go_router/example/lib/stateful_shell_route.dart
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return ScaffoldWithNestedNavigation(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            navigatorKey: _readNavigatorKey,
            routes: [
              GoRoute(
                  path: '/read',
                  name: AppRoute.read.name,
                  // pageBuilder: (context, state) => const NoTransitionPage(
                  //   child: ReadScreen(),
                  // ),
                  pageBuilder: (context, state) {
                    return CustomTransitionPage(
                      key: state.pageKey,
                      child: ReadScreen(),
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
                        // Change the opacity of the screen using a Curve based on the the animation's
                        // value
                        return FadeTransition(
                          opacity: CurveTween(curve: Curves.easeInOutCirc)
                              .animate(animation),
                          child: child,
                        );
                      },
                    );
                  },
                  routes: [
                    GoRoute(
                      path: 'keep',
                      name: AppRoute.keep.name,
                      parentNavigatorKey: _readNavigatorKey,
                      pageBuilder: (context, state) {
                        return const MaterialPage(
                          fullscreenDialog: true,
                          child: KeepsScreen(),
                        );
                      },
                    ),
                    GoRoute(
                      path: 'add',
                      name: AppRoute.editKeep.name,
                      parentNavigatorKey: _readNavigatorKey,
                      pageBuilder: (context, state) {
                        return MaterialPage(
                          fullscreenDialog: true,
                          child: EditKeepScreen(
                              keep: Keep.fromMap({
                            'title': state.queryParameters['title'],
                            'verse': state.queryParameters['verse'],
                            'note': state.queryParameters['note'],
                          }, state.queryParameters['id']!)),
                        );
                      },
                    ),
                    //     GoRoute(
                    //       path: 'edit',
                    //       name: AppRoute.editKeep.name,
                    //       parentNavigatorKey: _readNavigatorKey,
                    //       pageBuilder: (context, state) {
                    //         final keepId = state.pathParameters['id'];
                    //         return MaterialPage(
                    //           fullscreenDialog: true,
                    //           child: EditKeepScreen(keepId: keepId),
                    //         );
                    //       },
                    //     ),
                  ]),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _jobsNavigatorKey,
            routes: [
              GoRoute(
                path: '/proclaim',
                name: AppRoute.jobs.name,
                // pageBuilder: (context, state) => const NoTransitionPage(
                //   child: JobsScreen(),
                // ),
                pageBuilder: (context, state) {
                  return CustomTransitionPage(
                    key: state.pageKey,
                    child: JobsScreen(),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      // Change the opacity of the screen using a Curve based on the the animation's
                      // value
                      return FadeTransition(
                        opacity: CurveTween(curve: Curves.easeInOutCirc)
                            .animate(animation),
                        child: child,
                      );
                    },
                  );
                },
                // routes: [
                //   GoRoute(
                //     path: 'add',
                //     name: AppRoute.addJob.name,
                //     parentNavigatorKey: _rootNavigatorKey,
                //     pageBuilder: (context, state) {
                //       return const MaterialPage(
                //         fullscreenDialog: true,
                //         child: EditJobScreen(),
                //       );
                //     },
                //   ),
                //   GoRoute(
                //     path: ':id',
                //     name: AppRoute.job.name,
                //     pageBuilder: (context, state) {
                //       final id = state.pathParameters['id']!;
                //       return MaterialPage(
                //         child: JobEntriesScreen(jobId: id),
                //       );
                //     },
                //     routes: [
                //       // GoRoute(
                //       //   path: 'entries/add',
                //       //   name: AppRoute.addEntry.name,
                //       //   parentNavigatorKey: _rootNavigatorKey,
                //       //   pageBuilder: (context, state) {
                //       //     final jobId = state.pathParameters['id']!;
                //       //     return MaterialPage(
                //       //       fullscreenDialog: true,
                //       //       child: EntryScreen(
                //       //         jobId: jobId,
                //       //       ),
                //       //     );
                //       //   },
                //       // ),
                //       // GoRoute(
                //       //   path: 'entries/:eid',
                //       //   name: AppRoute.entry.name,
                //       //   pageBuilder: (context, state) {
                //       //     final jobId = state.pathParameters['id']!;
                //       //     final entryId = state.pathParameters['eid']!;
                //       //     final entry = state.extra as Entry?;
                //       //     return MaterialPage(
                //       //       child: EntryScreen(
                //       //         jobId: jobId,
                //       //         entryId: entryId,
                //       //         entry: entry,
                //       //       ),
                //       //     );
                //       //   },
                //       // ),
                //       // GoRoute(
                //       //   path: 'edit',
                //       //   name: AppRoute.editJob.name,
                //       //   pageBuilder: (context, state) {
                //       //     final jobId = state.pathParameters['id'];
                //       //     final job = state.extra as Job?;
                //       //     return MaterialPage(
                //       //       fullscreenDialog: true,
                //       //       child: EditJobScreen(jobId: jobId, job: job),
                //       //     );
                //       //   },
                //       // ),
                //     ],
                //   ),
                // ],
              ),
            ],
          ),

          // StatefulShellBranch(
          //   navigatorKey: _entriesNavigatorKey,
          //   routes: [
          //     GoRoute(
          //       path: '/entries',
          //       name: AppRoute.entries.name,
          //       pageBuilder: (context, state) => const NoTransitionPage(
          //         child: EntriesScreen(),
          //       ),
          //     ),
          //   ],
          // ),
          StatefulShellBranch(
            navigatorKey: _accountNavigatorKey,
            routes: [
              GoRoute(
                path: '/account',
                // name: AppRoute.profile.name,
                // pageBuilder: (context, state) => const NoTransitionPage(
                //   child: CustomProfileScreen(),
                // ),
                pageBuilder: (context, state) {
                  return CustomTransitionPage(
                    key: state.pageKey,
                    child: CustomProfileScreen(),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      // Change the opacity of the screen using a Curve based on the the animation's
                      // value
                      return FadeTransition(
                        opacity: CurveTween(curve: Curves.easeInOutCirc)
                            .animate(animation),
                        child: child,
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ],
      ),
    ],
    //errorBuilder: (context, state) => const NotFoundScreen(),
  );
}
