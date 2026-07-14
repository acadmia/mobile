import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'core/design_system/bordo_colors.dart';
import 'core/routing/main_navigation_scaffold.dart';
import 'features/catalog/ui/catalog_page.dart';
import 'features/catalog/ui/new_exercise_page.dart';
import 'features/catalog/ui/catalog_selector_page.dart';
import 'features/builder/ui/template_list_page.dart';
import 'features/builder/ui/template_builder_page.dart';
import 'features/execution/ui/active_workout_page.dart';
import 'features/analytics/ui/user_profile_page.dart';
import 'features/analytics/ui/workout_summary_page.dart';
import 'features/history/ui/history_page.dart';
import 'features/history/ui/past_template_selector_page.dart';
import 'features/history/ui/past_workout_page.dart';
import 'shared/models/template_model.dart';

void main() {
  runApp(const GymApp());
}

final _router = GoRouter(
  initialLocation: '/templates',
  routes: [
    // Menu Principal (Abas)
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return MainNavigationScaffold(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/templates',
              builder: (context, state) => const TemplateListPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/catalog',
              builder: (context, state) => const CatalogPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/history',
              builder: (context, state) => const HistoryPage(),
            ),
          ],
        ),
      ],
    ),
    
    // Telas Sobrepostas (Escondem o menu inferior)
    GoRoute(
      path: '/catalog-selector',
      builder: (context, state) => const CatalogSelectorPage(),
    ),
    GoRoute(
      path: '/new-exercise',
      builder: (context, state) => const NewExercisePage(),
    ),
    GoRoute(
      path: '/builder',
      builder: (context, state) => const TemplateBuilderPage(),
    ),
    GoRoute(
      path: '/workout',
      builder: (context, state) {
        final template = state.extra as TemplateModel;
        return ActiveWorkoutPage(template: template);
      },
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) => const UserProfilePage(),
    ),
    GoRoute(
      path: '/summary',
      builder: (context, state) {
        final duration = state.extra as int;
        return WorkoutSummaryPage(durationSeconds: duration);
      },
    ),
    GoRoute(
      path: '/past-workout-selector',
      builder: (context, state) {
        final date = state.extra as DateTime;
        return PastTemplateSelectorPage(selectedDate: date);
      },
    ),
    GoRoute(
      path: '/past-workout',
      builder: (context, state) {
        final map = state.extra as Map<String, dynamic>;
        return PastWorkoutPage(template: map['template'] as TemplateModel, date: map['date'] as DateTime);
      },
    ),
  ],
);

class GymApp extends StatelessWidget {
  const GymApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Bordo Gym',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: BordoColors.background,
        colorScheme: const ColorScheme.dark(
          primary: BordoColors.primary,
          secondary: BordoColors.accent,
          surface: BordoColors.surface,
        ),
        useMaterial3: false,
      ),
      routerConfig: _router,
    );
  }
}
