import 'package:flutter/material.dart';
import 'package:flutter_triple/flutter_triple.dart';
import 'package:go_router/go_router.dart';
import '../../../core/design_system/bordo_colors.dart';
import '../../../core/design_system/typography.dart';
import '../../../shared/models/exercise_model.dart';
import '../stores/catalog_store.dart';
import '../../../core/database/database_helper.dart';
import '../data/catalog_repository.dart';

class CatalogPage extends StatefulWidget {
  const CatalogPage({super.key});

  @override
  State<CatalogPage> createState() => _CatalogPageState();
}

class _CatalogPageState extends State<CatalogPage> {
  late final CatalogStore store;

  @override
  void initState() {
    super.initState();
    // Injeção de dependência simplificada para a Sprint 1
    final repository = CatalogRepository(DatabaseHelper());
    store = CatalogStore(repository);
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Catálogo', style: BordoTypography.header),
                  IconButton(
                    icon: const Icon(Icons.add, color: BordoColors.accent),
                    onPressed: () => context.push('/new-exercise').then((_) => store.loadExercises()),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Expanded(
                child: ScopedBuilder<CatalogStore, List<ExerciseModel>>(
                  store: store,
                  onLoading: (_) => const Center(
                    child: CircularProgressIndicator(color: BordoColors.primary),
                  ),
                  onError: (_, error) => const Center(
                    child: Text('Erro ao carregar', style: BordoTypography.body),
                  ),
                  onState: (_, state) {
                    if (state.isEmpty) {
                      return const Center(child: Text('Nenhum exercício encontrado', style: BordoTypography.bodySecondary));
                    }
                    
                    final sortedState = List<ExerciseModel>.from(state)..sort((a, b) => a.name.compareTo(b.name));
                    
                    final Map<String, List<ExerciseModel>> grouped = {};
                    for (var ex in sortedState) {
                      if (!grouped.containsKey(ex.muscleGroup)) {
                        grouped[ex.muscleGroup] = [];
                      }
                      grouped[ex.muscleGroup]!.add(ex);
                    }
                    
                    final sortedKeys = grouped.keys.toList()..sort();
                    
                    final List<dynamic> flattened = [];
                    for (var key in sortedKeys) {
                      flattened.add(key); // Header
                      flattened.addAll(grouped[key]!); // Items
                    }

                    return ListView.builder(
                      itemCount: flattened.length,
                      itemBuilder: (context, index) {
                        final item = flattened[index];
                        
                        if (item is String) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 24, bottom: 12),
                            child: Text(item.toUpperCase(), style: BordoTypography.title.copyWith(color: BordoColors.accent, fontSize: 16, letterSpacing: 2)),
                          );
                        }
                        
                        final exercise = item as ExerciseModel;
                        return Card(
                          color: BordoColors.surface,
                          margin: const EdgeInsets.only(bottom: 8),
                          shape: RoundedRectangleBorder(
                            side: BorderSide(color: BordoColors.primary.withOpacity(0.3), width: 1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: ListTile(
                            title: Text(exercise.name, style: BordoTypography.title.copyWith(fontSize: 18)),
                            trailing: exercise.isCustom 
                                ? const Icon(Icons.star, color: BordoColors.accent, size: 16) 
                                : null,
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
