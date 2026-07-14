import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'core/design_system/bordo_colors.dart';
import 'features/catalog/ui/catalog_page.dart';
import 'features/catalog/ui/new_exercise_page.dart';
import 'features/catalog/ui/catalog_selector_page.dart';
import 'features/builder/ui/template_list_page.dart';
import 'features/builder/ui/template_builder_page.dart';
import 'features/execution/ui/active_workout_page.dart';
import 'features/analytics/ui/user_profile_page.dart';
import 'features/analytics/ui/workout_summary_page.dart';
import 'shared/models/template_model.dart';

void main() {
  runApp(const GymApp());
}

final _router = GoRouter(
  initialLocation: '/templates',
  routes: [
    GoRoute(
      path: '/catalog',
      builder: (context, state) => const CatalogPage(),
    ),
    GoRoute(
      path: '/catalog-selector',
      builder: (context, state) => const CatalogSelectorPage(),
    ),
    GoRoute(
      path: '/new-exercise',
      builder: (context, state) => const NewExercisePage(),
    ),
    GoRoute(
      path: '/templates',
      builder: (context, state) => const TemplateListPage(),
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
