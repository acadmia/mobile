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
  String? _selectedGroup;
  List<String> _muscleGroups = [];
  bool _isSaving = false;
  bool _isCreatingNewGroup = false;

  @override
  void initState() {
    super.initState();
    _loadGroups();
  }

  Future<void> _loadGroups() async {
    final repository = CatalogRepository(DatabaseHelper());
    final groups = await repository.getDistinctMuscleGroups();
    setState(() {
      _muscleGroups = groups;
      if (groups.isNotEmpty) _selectedGroup = groups.first;
    });
  }

  Future<void> _save() async {
    if (_nameController.text.trim().isEmpty) return;
    
    final finalGroup = _isCreatingNewGroup ? _groupController.text.trim() : _selectedGroup;
    if (finalGroup == null || finalGroup.isEmpty) return;
    
    setState(() => _isSaving = true);
    
    final repository = CatalogRepository(DatabaseHelper());
    final model = ExerciseModel(
      name: _nameController.text.trim(),
      muscleGroup: finalGroup,
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
              const Text('Novo Exercício', style: BordoTypography.header),
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
              if (_isCreatingNewGroup)
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _groupController,
                        style: BordoTypography.body,
                        decoration: const InputDecoration(
                          labelText: 'Nome do Novo Grupo',
                          labelStyle: BordoTypography.bodySecondary,
                          enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: BordoColors.primary)),
                          focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: BordoColors.accent)),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: BordoColors.textSecondary),
                      onPressed: () => setState(() => _isCreatingNewGroup = false),
                    )
                  ],
                )
              else if (_muscleGroups.isNotEmpty)
                DropdownButtonFormField<String>(
                  value: _selectedGroup,
                  dropdownColor: BordoColors.surface,
                  decoration: const InputDecoration(
                    labelText: 'Grupo Muscular',
                    labelStyle: BordoTypography.bodySecondary,
                    enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: BordoColors.primary)),
                    focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: BordoColors.accent)),
                  ),
                  items: [
                    ..._muscleGroups.map((group) {
                      return DropdownMenuItem(
                        value: group,
                        child: Text(group, style: BordoTypography.body),
                      );
                    }),
                    const DropdownMenuItem(
                      value: 'NEW_GROUP',
                      child: Text('+ Criar Novo Grupo', style: TextStyle(color: BordoColors.accent, fontWeight: FontWeight.bold)),
                    ),
                  ],
                  onChanged: (val) {
                    if (val == 'NEW_GROUP') {
                      setState(() {
                        _isCreatingNewGroup = true;
                        _groupController.clear();
                      });
                    } else if (val != null) {
                      setState(() => _selectedGroup = val);
                    }
                  },
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
