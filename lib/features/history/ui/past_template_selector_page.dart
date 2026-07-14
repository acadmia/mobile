import 'package:flutter/material.dart';
import 'package:flutter_triple/flutter_triple.dart';
import 'package:go_router/go_router.dart';
import '../../../core/design_system/bordo_colors.dart';
import '../../../core/design_system/typography.dart';
import '../../../shared/models/template_model.dart';
import '../../builder/stores/template_list_store.dart';
import '../../../core/database/database_helper.dart';
import '../../builder/data/template_repository.dart';

class PastTemplateSelectorPage extends StatefulWidget {
  final DateTime selectedDate;
  const PastTemplateSelectorPage({super.key, required this.selectedDate});

  @override
  State<PastTemplateSelectorPage> createState() => _PastTemplateSelectorPageState();
}

class _PastTemplateSelectorPageState extends State<PastTemplateSelectorPage> {
  late final TemplateListStore store;

  @override
  void initState() {
    super.initState();
    final repository = TemplateRepository(DatabaseHelper());
    store = TemplateListStore(repository);
    store.loadTemplates();
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('Treino do dia ${_formatDate(widget.selectedDate)}', style: BordoTypography.title),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Qual treino você fez?', style: BordoTypography.header),
              const SizedBox(height: 24),
              Expanded(
                child: ScopedBuilder<TemplateListStore, List<TemplateModel>>(
                  store: store,
                  onLoading: (_) => const Center(child: CircularProgressIndicator(color: BordoColors.primary)),
                  onState: (_, state) {
                    if (state.isEmpty) {
                      return const Center(child: Text('Nenhum treino montado ainda.', style: BordoTypography.bodySecondary));
                    }
                    return ListView.builder(
                      itemCount: state.length,
                      itemBuilder: (context, index) {
                        final template = state[index];
                        return Card(
                          color: BordoColors.surface,
                          margin: const EdgeInsets.only(bottom: 8),
                          child: ListTile(
                            title: Text(template.name, style: BordoTypography.title.copyWith(fontSize: 18)),
                            subtitle: Text('${template.exercises.length} exercícios', style: BordoTypography.bodySecondary),
                            trailing: const Icon(Icons.arrow_forward_ios, color: BordoColors.accent, size: 16),
                            onTap: () async {
                              await context.push('/past-workout', extra: {
                                'template': template,
                                'date': widget.selectedDate,
                              });
                              // Quando o form fechar, fecha o seletor também para voltar ao histórico
                              if (context.mounted) {
                                context.pop();
                              }
                            },
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
