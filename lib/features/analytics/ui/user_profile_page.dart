import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/design_system/bordo_colors.dart';
import '../../../core/design_system/typography.dart';
import '../../../core/design_system/widgets/bordo_button.dart';
import '../../../shared/models/user_profile_model.dart';
import '../../../core/database/database_helper.dart';
import '../data/analytics_repository.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  final _ageCtrl = TextEditingController();
  final _weightCtrl = TextEditingController();
  final _heightCtrl = TextEditingController();
  final _hrCtrl = TextEditingController();
  String _gender = 'M';
  bool _isLoading = true;

  late final AnalyticsRepository _repository;

  @override
  void initState() {
    super.initState();
    _repository = AnalyticsRepository(DatabaseHelper());
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final profile = await _repository.getProfile();
    if (profile != null) {
      _ageCtrl.text = profile.age.toString();
      _weightCtrl.text = profile.weight.toString();
      _heightCtrl.text = profile.height.toString();
      _hrCtrl.text = profile.heartRate.toString();
      _gender = profile.gender;
    }
    setState(() => _isLoading = false);
  }

  Future<void> _save() async {
    final age = int.tryParse(_ageCtrl.text) ?? 0;
    final weight = double.tryParse(_weightCtrl.text) ?? 0.0;
    final height = double.tryParse(_heightCtrl.text) ?? 0.0;
    final hr = double.tryParse(_hrCtrl.text) ?? 0.0;

    if (age > 0 && weight > 0) {
      final profile = UserProfileModel(
        age: age,
        weight: weight,
        height: height,
        gender: _gender,
        heartRate: hr > 0 ? hr : 120.0,
      );
      await _repository.saveProfile(profile);
      if (mounted) context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return const Scaffold(body: Center(child: CircularProgressIndicator(color: BordoColors.primary)));

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
              const Text('Meu Biotipo', style: BordoTypography.header),
              const SizedBox(height: 8),
              const Text('Esses dados calibram a inteligência analítica do app.', style: BordoTypography.bodySecondary),
              const SizedBox(height: 32),
              Expanded(
                child: ListView(
                  children: [
                    Row(
                      children: [
                        Expanded(child: _buildField('Idade', _ageCtrl)),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Gênero', style: BordoTypography.bodySecondary),
                              const SizedBox(height: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12),
                                decoration: BoxDecoration(
                                  border: Border.all(color: BordoColors.primary),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    value: _gender,
                                    dropdownColor: BordoColors.surface,
                                    isExpanded: true,
                                    items: const [
                                      DropdownMenuItem(value: 'M', child: Text('Masculino', style: BordoTypography.body)),
                                      DropdownMenuItem(value: 'F', child: Text('Feminino', style: BordoTypography.body)),
                                    ],
                                    onChanged: (val) => setState(() => _gender = val!),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(child: _buildField('Peso (Kg)', _weightCtrl)),
                        const SizedBox(width: 16),
                        Expanded(child: _buildField('Altura (cm)', _heightCtrl)),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildField('BPM Médio no Treino', _hrCtrl),
                  ],
                ),
              ),
              BordoButton(
                label: 'SALVAR DADOS',
                onPressed: _save,
                isAccent: true,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: BordoTypography.bodySecondary),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          style: BordoTypography.body,
          decoration: const InputDecoration(
            enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: BordoColors.primary)),
            focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: BordoColors.accent)),
          ),
        ),
      ],
    );
  }
}
