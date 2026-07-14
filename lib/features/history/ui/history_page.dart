import 'package:flutter/material.dart';
import 'package:flutter_triple/flutter_triple.dart';
import '../../../core/design_system/bordo_colors.dart';
import '../../../core/design_system/typography.dart';
import '../../../shared/models/history_session_model.dart';
import '../stores/history_store.dart';
import '../../../core/database/database_helper.dart';
import '../data/history_repository.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  late final HistoryStore store;

  @override
  void initState() {
    super.initState();
    store = HistoryStore(HistoryRepository(DatabaseHelper()));
    store.loadHistory();
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
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
              const Text('Histórico', style: BordoTypography.header),
              const SizedBox(height: 24),
              Expanded(
                child: ScopedBuilder<HistoryStore, List<HistorySessionModel>>(
                  store: store,
                  onLoading: (_) => const Center(child: CircularProgressIndicator(color: BordoColors.primary)),
                  onError: (_, error) => const Center(child: Text('Erro ao carregar o histórico', style: BordoTypography.body)),
                  onState: (_, state) {
                    if (state.isEmpty) {
                      return const Center(child: Text('Nenhum treino finalizado ainda.', style: BordoTypography.bodySecondary));
                    }
                    return ListView.builder(
                      itemCount: state.length,
                      itemBuilder: (context, index) {
                        final session = state[index];
                        return Card(
                          color: BordoColors.surface,
                          margin: const EdgeInsets.only(bottom: 8),
                          shape: RoundedRectangleBorder(
                            side: BorderSide(color: BordoColors.primary.withOpacity(0.3)),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: ListTile(
                            leading: const Icon(Icons.check_circle, color: BordoColors.accent),
                            title: Text(session.templateName, style: BordoTypography.title.copyWith(fontSize: 18)),
                            subtitle: Text('Data: ${_formatDate(session.startTime)}', style: BordoTypography.bodySecondary),
                            trailing: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text('${session.totalSets}', style: BordoTypography.body.copyWith(fontWeight: FontWeight.bold)),
                                const Text('Séries', style: BordoTypography.bodySecondary),
                              ],
                            ),
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
