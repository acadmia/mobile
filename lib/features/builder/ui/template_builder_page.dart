import 'package:flutter/material.dart';
import 'package:flutter_triple/flutter_triple.dart';
import 'package:go_router/go_router.dart';
import '../../../core/design_system/bordo_colors.dart';
import '../../../core/design_system/typography.dart';
import '../../../core/design_system/widgets/bordo_button.dart';
import '../../../shared/models/exercise_model.dart';
import '../stores/template_builder_store.dart';
import '../../../core/database/database_helper.dart';
import '../data/template_repository.dart';

class TemplateBuilderPage extends StatefulWidget {
  const TemplateBuilderPage({super.key});

  @override
  State<TemplateBuilderPage> createState() => _TemplateBuilderPageState();
}

class _TemplateBuilderPageState extends State<TemplateBuilderPage> {
  late final TemplateBuilderStore store;
  final _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final repository = TemplateRepository(DatabaseHelper());
    store = TemplateBuilderStore(repository);
  }

  void _showCatalogModal() {
    context.push<ExerciseModel>('/catalog-selector').then((selectedExercise) {
      if (selectedExercise != null) {
        store.addExercise(selectedExercise);
      }
    });
  }

  Future<void> _saveTemplate() async {
    if (_nameController.text.trim().isEmpty || store.state.isEmpty) return;
    await store.saveTemplate(_nameController.text);
    if (mounted) context.pop();
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
              TextField(
                controller: _nameController,
                style: BordoTypography.header,
                decoration: const InputDecoration(
                  hintText: 'Nome do Treino',
                  hintStyle: TextStyle(color: BordoColors.textSecondary, fontSize: 32, fontWeight: FontWeight.bold),
                  border: InputBorder.none,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ScopedBuilder<TemplateBuilderStore, List<ExerciseModel>>(
                  store: store,
                  onState: (_, state) {
                    if (state.isEmpty) {
                      return const Center(
                        child: Text('Toque em + para adicionar exercícios', style: BordoTypography.bodySecondary),
                      );
                    }
                    return ReorderableListView.builder(
                      itemCount: state.length,
                      onReorder: store.reorderExercises,
                      proxyDecorator: (child, index, animation) => Material(
                        color: Colors.transparent,
                        child: child,
                      ),
                      itemBuilder: (context, index) {
                        final exercise = state[index];
                        return Card(
                          key: ValueKey('${exercise.id}_$index'),
                          color: BordoColors.surface,
                          margin: const EdgeInsets.only(bottom: 8),
                          child: ListTile(
                            leading: const Icon(Icons.drag_handle, color: BordoColors.textSecondary),
                            title: Text(exercise.name, style: BordoTypography.body),
                            subtitle: Text(exercise.muscleGroup, style: BordoTypography.bodySecondary),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete_outline, color: BordoColors.textSecondary),
                              onPressed: () => store.removeExercise(index),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: const BorderSide(color: BordoColors.primary),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      onPressed: _showCatalogModal,
                      child: const Text('+ EXERCÍCIO', style: TextStyle(color: BordoColors.textPrimary)),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: BordoButton(
                      label: 'SALVAR',
                      onPressed: _saveTemplate,
                      isAccent: true,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
