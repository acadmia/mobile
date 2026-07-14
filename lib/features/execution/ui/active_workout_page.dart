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
    
    _workoutStore.startWorkout(widget.template.id);
  }

  @override
  void dispose() {
    _timerStore.stopTimer();
    super.dispose();
  }

  String _formatTime(int seconds) {
    final m = (seconds / 60).floor().toString().padLeft(2, '0');
    final s = (seconds % 60).toString().padLeft(2, '0');
    return '\$m:\$s';
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
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: widget.template.exercises.length,
                itemBuilder: (context, index) {
                  final exercise = widget.template.exercises[index];
                  return ExerciseExecutionCard(
                    exerciseName: exercise.name,
                    onSetCompleted: (weight, reps) {
                      _workoutStore.registerSet(
                        exerciseId: exercise.id!,
                        weight: weight,
                        reps: reps,
                      );
                      // Inicia ou Reseta o Cronômetro
                      _timerStore.startOrResetTimer();
                    },
                  );
                },
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
                      const Text('Cronômetro', style: BordoTypography.bodySecondary),
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
  final Function(double, int) onSetCompleted;

  const ExerciseExecutionCard({
    super.key,
    required this.exerciseName,
    required this.onSetCompleted,
  });

  @override
  State<ExerciseExecutionCard> createState() => _ExerciseExecutionCardState();
}

class _ExerciseExecutionCardState extends State<ExerciseExecutionCard> {
  final _weightCtrl = TextEditingController();
  final _repsCtrl = TextEditingController();
  bool _isCompleted = false;

  void _completeSet() {
    final weight = double.tryParse(_weightCtrl.text) ?? 0.0;
    final reps = int.tryParse(_repsCtrl.text) ?? 0;
    
    if (weight > 0 && reps > 0) {
      setState(() => _isCompleted = true);
      widget.onSetCompleted(weight, reps);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: _isCompleted ? BordoColors.primary.withOpacity(0.2) : BordoColors.surface,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        side: BorderSide(color: _isCompleted ? BordoColors.accent : BordoColors.primary.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.exerciseName, style: BordoTypography.title),
            const SizedBox(height: 16),
            Row(
              children: [
                BruteInput(controller: _weightCtrl, label: 'kg'),
                const SizedBox(width: 16),
                BruteInput(controller: _repsCtrl, label: 'reps'),
                const Spacer(),
                IconButton(
                  icon: Icon(
                    Icons.check_circle,
                    color: _isCompleted ? BordoColors.accent : BordoColors.textSecondary,
                    size: 40,
                  ),
                  onPressed: _isCompleted ? null : _completeSet,
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
