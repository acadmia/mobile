import 'package:flutter/material.dart';
import 'package:flutter_triple/flutter_triple.dart';
import 'package:go_router/go_router.dart';
import '../../../core/design_system/bordo_colors.dart';
import '../../../core/design_system/typography.dart';
import '../../../shared/models/exercise_model.dart';
import '../../catalog/stores/catalog_store.dart';
import '../../../core/database/database_helper.dart';
import '../../catalog/data/catalog_repository.dart';

class CatalogSelectorPage extends StatefulWidget {
  const CatalogSelectorPage({super.key});

  @override
  State<CatalogSelectorPage> createState() => _CatalogSelectorPageState();
}

class _CatalogSelectorPageState extends State<CatalogSelectorPage> {
  late final CatalogStore store;

  @override
  void initState() {
    super.initState();
    store = CatalogStore(CatalogRepository(DatabaseHelper()));
    store.loadExercises();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, color: BordoColors.textPrimary),
                onPressed: () => context.pop(),
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.zero,
              ),
              const SizedBox(height: 16),
              const Text('Selecionar Exercício', style: BordoTypography.header),
              const SizedBox(height: 24),
              Expanded(
                child: ScopedBuilder<CatalogStore, List<ExerciseModel>>(
                  store: store,
                  onLoading: (_) => const Center(child: CircularProgressIndicator(color: BordoColors.primary)),
                  onState: (_, state) {
                    return ListView.builder(
                      itemCount: state.length,
                      itemBuilder: (context, index) {
                        final exercise = state[index];
                        return Card(
                          color: BordoColors.surface,
                          margin: const EdgeInsets.only(bottom: 8),
                          child: ListTile(
                            title: Text(exercise.name, style: BordoTypography.body),
                            subtitle: Text(exercise.muscleGroup, style: BordoTypography.bodySecondary),
                            onTap: () => context.pop(exercise),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
