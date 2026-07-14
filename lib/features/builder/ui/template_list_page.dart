import 'package:flutter/material.dart';
import 'package:flutter_triple/flutter_triple.dart';
import 'package:go_router/go_router.dart';
import '../../../core/design_system/bordo_colors.dart';
import '../../../core/design_system/typography.dart';
import '../../../shared/models/template_model.dart';
import '../stores/template_list_store.dart';
import '../../../core/database/database_helper.dart';
import '../data/template_repository.dart';

class TemplateListPage extends StatefulWidget {
  const TemplateListPage({super.key});

  @override
  State<TemplateListPage> createState() => _TemplateListPageState();
}

class _TemplateListPageState extends State<TemplateListPage> {
  late final TemplateListStore store;

  @override
  void initState() {
    super.initState();
    final repository = TemplateRepository(DatabaseHelper());
    store = TemplateListStore(repository);
    store.loadTemplates();
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
                  const Text('Meus Treinos', style: BordoTypography.header),
                  IconButton(
                    icon: const Icon(Icons.add, color: BordoColors.accent),
                    onPressed: () => context.push('/builder').then((_) => store.loadTemplates()),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Expanded(
                child: ScopedBuilder<TemplateListStore, List<TemplateModel>>(
                  store: store,
                  onLoading: (_) => const Center(child: CircularProgressIndicator(color: BordoColors.primary)),
                  onError: (_, error) => const Center(child: Text('Erro ao carregar treinos', style: BordoTypography.body)),
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
                          shape: RoundedRectangleBorder(
                            side: BorderSide(color: BordoColors.primary.withOpacity(0.3)),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: ListTile(
                            title: Text(template.name, style: BordoTypography.title.copyWith(fontSize: 18)),
                            subtitle: Text('${template.exercises.length} exercícios', style: BordoTypography.bodySecondary),
                            trailing: const Icon(Icons.play_arrow, color: BordoColors.accent),
                            onTap: () {
                              context.push('/workout', extra: template);
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
