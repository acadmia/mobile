import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/design_system/bordo_colors.dart';
import '../../../core/design_system/typography.dart';
import '../../../core/design_system/widgets/bordo_button.dart';
import '../../../shared/models/template_model.dart';
import '../../../shared/models/workout_set_model.dart';
import '../../../core/database/database_helper.dart';
import '../../execution/data/workout_repository.dart';

class PastWorkoutPage extends StatefulWidget {
  final TemplateModel template;
  final DateTime date;
  
  const PastWorkoutPage({super.key, required this.template, required this.date});

  @override
  State<PastWorkoutPage> createState() => _PastWorkoutPageState();
}

class _PastWorkoutPageState extends State<PastWorkoutPage> {
  final WorkoutRepository _repository = WorkoutRepository(DatabaseHelper());
  bool _isSaving = false;

  final Map<int, List<_PastSetData>> _setsData = {};

  @override
  void initState() {
    super.initState();
    for (var ex in widget.template.exercises) {
      if (ex.id != null) {
        _setsData[ex.id!] = [_PastSetData(weightCtrl: TextEditingController(), repsCtrl: TextEditingController())];
      }
    }
  }

  Future<void> _savePastWorkout() async {
    setState(() => _isSaving = true);
    try {
      final sessionId = await _repository.startSession(widget.template.id, customStartTime: widget.date);
      
      for (var exId in _setsData.keys) {
        for (var setData in _setsData[exId]!) {
          final w = double.tryParse(setData.weightCtrl.text) ?? 0.0;
          final r = int.tryParse(setData.repsCtrl.text) ?? 0;
          
          if (w > 0 && r > 0) {
            final setModel = WorkoutSetModel(
              sessionId: sessionId,
              exerciseId: exId,
              weight: w,
              reps: r,
              completedAt: widget.date,
            );
            await _repository.saveSet(setModel);
          }
        }
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(backgroundColor: BordoColors.accent, content: Text('Treino passado registrado com sucesso!')));
        context.pop(); 
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro: \$e')));
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('Log Retroativo', style: BordoTypography.title),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: widget.template.exercises.length,
                itemBuilder: (context, index) {
                  final exercise = widget.template.exercises[index];
                  final sets = _setsData[exercise.id] ?? [];
                  
                  return Card(
                    color: BordoColors.surface,
                    margin: const EdgeInsets.only(bottom: 16),
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: BordoColors.primary.withOpacity(0.3)),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(exercise.name, style: BordoTypography.title),
                          const SizedBox(height: 16),
                          ...List.generate(sets.length, (setIndex) {
                            final setData = sets[setIndex];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Row(
                                children: [
                                  Text('\${setIndex + 1}', style: BordoTypography.bodySecondary.copyWith(fontWeight: FontWeight.bold)),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: TextField(
                                      controller: setData.weightCtrl,
                                      keyboardType: TextInputType.number,
                                      style: BordoTypography.body,
                                      textAlign: TextAlign.center,
                                      decoration: const InputDecoration(labelText: 'kg', labelStyle: BordoTypography.bodySecondary),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: TextField(
                                      controller: setData.repsCtrl,
                                      keyboardType: TextInputType.number,
                                      style: BordoTypography.body,
                                      textAlign: TextAlign.center,
                                      decoration: const InputDecoration(labelText: 'reps', labelStyle: BordoTypography.bodySecondary),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton.icon(
                              icon: const Icon(Icons.add, color: BordoColors.accent),
                              label: const Text('Mais 1 Série', style: TextStyle(color: BordoColors.accent)),
                              onPressed: () {
                                setState(() {
                                  _setsData[exercise.id!]!.add(_PastSetData(weightCtrl: TextEditingController(), repsCtrl: TextEditingController()));
                                });
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: BordoColors.surface,
                border: const Border(top: BorderSide(color: BordoColors.primary)),
              ),
              child: _isSaving 
                ? const Center(child: CircularProgressIndicator(color: BordoColors.accent))
                : BordoButton(
                    label: 'SALVAR TREINO',
                    onPressed: _savePastWorkout,
                    isAccent: true,
                  ),
            )
          ],
        ),
      ),
    );
  }
}

class _PastSetData {
  final TextEditingController weightCtrl;
  final TextEditingController repsCtrl;
  _PastSetData({required this.weightCtrl, required this.repsCtrl});
}
