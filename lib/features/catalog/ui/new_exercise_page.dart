import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/design_system/bordo_colors.dart';
import '../../../core/design_system/typography.dart';
import '../../../core/design_system/widgets/bordo_button.dart';
import '../../../shared/models/exercise_model.dart';
import '../../../core/database/database_helper.dart';
import '../data/catalog_repository.dart';

class NewExercisePage extends StatefulWidget {
  const NewExercisePage({super.key});

  @override
  State<NewExercisePage> createState() => _NewExercisePageState();
}

class _NewExercisePageState extends State<NewExercisePage> {
  final _nameController = TextEditingController();
  final _groupController = TextEditingController();
  bool _isSaving = false;

  Future<void> _save() async {
    if (_nameController.text.trim().isEmpty || _groupController.text.trim().isEmpty) return;
    
    setState(() => _isSaving = true);
    
    final repository = CatalogRepository(DatabaseHelper());
    final model = ExerciseModel(
      name: _nameController.text.trim(),
      muscleGroup: _groupController.text.trim(),
      isCustom: true,
    );
    
    await repository.saveCustomExercise(model);
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
              const Text('A Máquina Diferentona', style: BordoTypography.header),
              const SizedBox(height: 8),
              const Text('Cadastre um exercício customizado.', style: BordoTypography.bodySecondary),
              const SizedBox(height: 32),
              TextField(
                controller: _nameController,
                style: BordoTypography.body,
                decoration: const InputDecoration(
                  labelText: 'Nome do Exercício',
                  labelStyle: BordoTypography.bodySecondary,
                  enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: BordoColors.primary)),
                  focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: BordoColors.accent)),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _groupController,
                style: BordoTypography.body,
                decoration: const InputDecoration(
                  labelText: 'Grupo Muscular',
                  labelStyle: BordoTypography.bodySecondary,
                  enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: BordoColors.primary)),
                  focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: BordoColors.accent)),
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: _isSaving
                    ? const Center(child: CircularProgressIndicator(color: BordoColors.accent))
                    : BordoButton(
                        label: 'SALVAR',
                        onPressed: _save,
                        isAccent: true,
                      ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
