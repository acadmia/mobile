import 'package:flutter/material.dart';
import 'package:flutter_triple/flutter_triple.dart';
import 'package:go_router/go_router.dart';
import '../../../core/design_system/bordo_colors.dart';
import '../../../core/design_system/typography.dart';
import '../../../core/design_system/widgets/bordo_button.dart';
import '../../../core/design_system/widgets/brute_input.dart';
import '../../../shared/models/template_model.dart';
import '../stores/active_workout_store.dart';
import '../stores/timer_store.dart';
import '../../../core/database/database_helper.dart';
import '../data/workout_repository.dart';

class ActiveWorkoutPage extends StatefulWidget {
  final TemplateModel template;
  
  const ActiveWorkoutPage({super.key, required this.template});

  @override
  State<ActiveWorkoutPage> createState() => _ActiveWorkoutPageState();
}

class _ActiveWorkoutPageState extends State<ActiveWorkoutPage> {
  late final ActiveWorkoutStore _workoutStore;
  late final TimerStore _timerStore;
  late final DateTime _startTime;

  @override
  void initState() {
    super.initState();
    _startTime = DateTime.now();
    final repository = WorkoutRepository(DatabaseHelper());
    _workoutStore = ActiveWorkoutStore(repository);
    _timerStore = TimerStore();
    
    _workoutStore.startWorkout(widget.template);
  }

  @override
  void dispose() {
    _timerStore.stopTimer();
    super.dispose();
  }

  String _formatTime(int seconds) {
    final m = (seconds / 60).floor().toString().padLeft(2, '0');
    final s = (seconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.close, color: BordoColors.textPrimary),
                    onPressed: () => context.pop(),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      widget.template.name,
                      style: BordoTypography.header,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ScopedBuilder<ActiveWorkoutStore, ActiveWorkoutState>(
                store: _workoutStore,
                onLoading: (_) => const Center(child: CircularProgressIndicator(color: BordoColors.accent)),
                onState: (_, state) {
                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: widget.template.exercises.length,
                    itemBuilder: (context, index) {
                      final exercise = widget.template.exercises[index];
                      final lastPerf = state.lastPerformances[exercise.id];

                      return ExerciseExecutionCard(
                        exerciseName: exercise.name,
                        initialWeight: lastPerf?.weight,
                        initialReps: lastPerf?.reps,
                        onSetCompleted: (weight, reps) {
                          _workoutStore.registerSet(
                            exerciseId: exercise.id!,
                            weight: weight,
                            reps: reps,
                          );
                          _timerStore.startOrResetTimer();
                        },
                      );
                    },
                  );
                }
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: BordoColors.surface.withOpacity(0.95),
                border: const Border(top: BorderSide(color: BordoColors.primary, width: 2)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('Descanso / Execução', style: BordoTypography.bodySecondary),
                      ScopedBuilder<TimerStore, int>(
                        store: _timerStore,
                        onState: (_, time) {
                          return Text(
                            _formatTime(time),
                            style: BordoTypography.header.copyWith(
                              color: time > 0 ? BordoColors.accent : BordoColors.textPrimary,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  BordoButton(
                    label: 'FINALIZAR',
                    onPressed: () {
                      final duration = DateTime.now().difference(_startTime).inSeconds;
                      context.pushReplacement('/summary', extra: duration);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ExerciseExecutionCard extends StatefulWidget {
  final String exerciseName;
  final double? initialWeight;
  final int? initialReps;
  final Function(double, int) onSetCompleted;

  const ExerciseExecutionCard({
    super.key,
    required this.exerciseName,
    this.initialWeight,
    this.initialReps,
    required this.onSetCompleted,
  });

  @override
  State<ExerciseExecutionCard> createState() => _ExerciseExecutionCardState();
}

class _SetData {
  final TextEditingController weightCtrl;
  final TextEditingController repsCtrl;
  bool isCompleted;

  _SetData({required this.weightCtrl, required this.repsCtrl, this.isCompleted = false});
}

class _ExerciseExecutionCardState extends State<ExerciseExecutionCard> {
  final List<_SetData> _sets = [];

  @override
  void initState() {
    super.initState();
    _addNewSetRow(
      weight: widget.initialWeight,
      reps: widget.initialReps,
    );
  }

  void _addNewSetRow({double? weight, int? reps}) {
    final wCtrl = TextEditingController(text: weight != null && weight > 0 ? weight.toStringAsFixed(1).replaceAll('.0', '') : '');
    final rCtrl = TextEditingController(text: reps != null && reps > 0 ? reps.toString() : '');
    _sets.add(_SetData(weightCtrl: wCtrl, repsCtrl: rCtrl));
  }

  void _completeSet(int index) {
    final setData = _sets[index];
    final w = double.tryParse(setData.weightCtrl.text) ?? 0.0;
    final r = int.tryParse(setData.repsCtrl.text) ?? 0;
    
    if (w > 0 && r > 0) {
      setState(() {
        setData.isCompleted = true;
        _addNewSetRow(weight: w, reps: r);
      });
      widget.onSetCompleted(w, r);
    }
  }

  @override
  Widget build(BuildContext context) {
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
            Text(widget.exerciseName, style: BordoTypography.title),
            const SizedBox(height: 16),
            ...List.generate(_sets.length, (index) {
              final setData = _sets[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: Row(
                  children: [
                    Container(
                      width: 24,
                      alignment: Alignment.center,
                      child: Text('${index + 1}', style: BordoTypography.bodySecondary.copyWith(fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(width: 8),
                    BruteInput(controller: setData.weightCtrl, label: 'kg', readOnly: setData.isCompleted),
                    const SizedBox(width: 16),
                    BruteInput(controller: setData.repsCtrl, label: 'reps', readOnly: setData.isCompleted),
                    const Spacer(),
                    IconButton(
                      icon: Icon(
                        Icons.check_circle,
                        color: setData.isCompleted ? BordoColors.accent : BordoColors.textSecondary,
                        size: 32,
                      ),
                      onPressed: setData.isCompleted ? null : () => _completeSet(index),
                    )
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
