import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/design_system/bordo_colors.dart';
import '../../../core/design_system/typography.dart';
import '../../../core/design_system/widgets/bordo_button.dart';
import '../../../shared/models/user_profile_model.dart';
import '../../../core/database/database_helper.dart';
import '../data/analytics_repository.dart';
import '../services/health_calculator_service.dart';

class WorkoutSummaryPage extends StatefulWidget {
  final int durationSeconds;

  const WorkoutSummaryPage({super.key, required this.durationSeconds});

  @override
  State<WorkoutSummaryPage> createState() => _WorkoutSummaryPageState();
}

class _WorkoutSummaryPageState extends State<WorkoutSummaryPage> {
  UserProfileModel? _profile;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final repo = AnalyticsRepository(DatabaseHelper());
    _profile = await repo.getProfile();
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return const Scaffold(body: Center(child: CircularProgressIndicator(color: BordoColors.primary)));

    final timeInHours = widget.durationSeconds / 3600;
    double calories = 0;
    String zone = 'Desconhecida';

    if (_profile != null) {
      calories = HealthCalculatorService.calculateCalories(
        gender: _profile!.gender,
        age: _profile!.age,
        weightKg: _profile!.weight,
        avgHeartRate: _profile!.heartRate,
        timeInHours: timeInHours,
      );
      
      final maxHr = HealthCalculatorService.calculateMaxHeartRate(_profile!.age);
      final percent = (_profile!.heartRate / maxHr) * 100;
      
      if (percent >= 90) {
        zone = 'Extrema (VO2 Max)';
      } else if (percent >= 80) {
        zone = 'Intensa (Anaeróbica)';
      } else if (percent >= 70) {
        zone = 'Moderada (Aeróbica)';
      } else if (percent >= 60) {
        zone = 'Leve (Queima de Gordura)';
      } else {
        zone = 'Descanso (Aquecimento)';
      }
    }

    final min = (widget.durationSeconds / 60).floor();

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(Icons.emoji_events, size: 80, color: BordoColors.accent),
              const SizedBox(height: 24),
              const Text('Treino Finalizado!', style: BordoTypography.header),
              const SizedBox(height: 8),
              Text('Duração: $min minutos', style: BordoTypography.bodySecondary),
              const SizedBox(height: 48),
              if (_profile == null)
                const Text(
                  'Cadastre seu Biotipo no menu principal para ver as estimativas científicas de Gasto Calórico.',
                  style: BordoTypography.body,
                  textAlign: TextAlign.center,
                )
              else ...[
                _buildStatCard('Gasto Calórico Estimado', '${calories.toStringAsFixed(0)} kcal'),
                const SizedBox(height: 16),
                _buildStatCard('Zona de Treinamento', zone),
              ],
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: BordoButton(
                  label: 'VOLTAR AO INÍCIO',
                  onPressed: () => context.go('/templates'),
                  isAccent: true,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String label, String value) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: BordoColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: BordoColors.primary.withOpacity(0.5)),
      ),
      child: Column(
        children: [
          Text(label, style: BordoTypography.bodySecondary),
          const SizedBox(height: 8),
          Text(value, style: BordoTypography.title.copyWith(fontSize: 24, color: BordoColors.accent)),
        ],
      ),
    );
  }
}
