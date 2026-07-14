import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'core/design_system/bordo_colors.dart';
import 'features/catalog/ui/catalog_page.dart';
import 'features/catalog/ui/new_exercise_page.dart';
import 'features/catalog/ui/catalog_selector_page.dart';
import 'features/builder/ui/template_list_page.dart';
import 'features/builder/ui/template_builder_page.dart';

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
