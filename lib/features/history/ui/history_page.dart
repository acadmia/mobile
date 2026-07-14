import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_triple/flutter_triple.dart';
import 'package:table_calendar/table_calendar.dart';
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
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    store = HistoryStore(HistoryRepository(DatabaseHelper()));
    store.loadHistory();
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  bool _isSameDate(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  bool _isPastDay(DateTime day) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final target = DateTime(day.year, day.month, day.day);
    return target.isBefore(today);
  }

  List<HistorySessionModel> _getEventsForDay(DateTime day, List<HistorySessionModel> allSessions) {
    return allSessions.where((session) => _isSameDate(session.startTime, day)).toList();
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
              const SizedBox(height: 16),
              Expanded(
                child: ScopedBuilder<HistoryStore, List<HistorySessionModel>>(
                  store: store,
                  onLoading: (_) => const Center(child: CircularProgressIndicator(color: BordoColors.primary)),
                  onError: (_, error) => const Center(child: Text('Erro ao carregar o histórico', style: BordoTypography.body)),
                  onState: (_, state) {
                    final selectedSessions = _selectedDay != null ? _getEventsForDay(_selectedDay!, state) : [];

                    return Column(
                      children: [
                        TableCalendar(
                          firstDay: DateTime.utc(2020, 1, 1),
                          lastDay: DateTime.utc(2030, 12, 31),
                          focusedDay: _focusedDay,
                          selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                          onDaySelected: (selectedDay, focusedDay) {
                            setState(() {
                              _selectedDay = selectedDay;
                              _focusedDay = focusedDay;
                            });
                          },
                          eventLoader: (day) => _getEventsForDay(day, state),
                          calendarStyle: const CalendarStyle(
                            todayDecoration: BoxDecoration(
                              color: BordoColors.primary,
                              shape: BoxShape.circle,
                            ),
                            selectedDecoration: BoxDecoration(
                              color: BordoColors.accent,
                              shape: BoxShape.circle,
                            ),
                            markerDecoration: BoxDecoration(
                              color: BordoColors.accent,
                              shape: BoxShape.circle,
                            ),
                            defaultTextStyle: TextStyle(color: BordoColors.textPrimary),
                            weekendTextStyle: TextStyle(color: BordoColors.textSecondary),
                          ),
                          headerStyle: const HeaderStyle(
                            formatButtonVisible: false,
                            titleCentered: true,
                            titleTextStyle: BordoTypography.title,
                            leftChevronIcon: Icon(Icons.chevron_left, color: BordoColors.textPrimary),
                            rightChevronIcon: Icon(Icons.chevron_right, color: BordoColors.textPrimary),
                          ),
                          daysOfWeekStyle: const DaysOfWeekStyle(
                            weekdayStyle: TextStyle(color: BordoColors.textSecondary),
                            weekendStyle: TextStyle(color: BordoColors.textSecondary),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Expanded(
                          child: selectedSessions.isEmpty
                              ? Center(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Text('Nenhum treino neste dia.', style: BordoTypography.bodySecondary),
                                      if (_selectedDay != null && _isPastDay(_selectedDay!)) ...[
                                        const SizedBox(height: 24),
                                        ElevatedButton.icon(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: BordoColors.accent,
                                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                          ),
                                          icon: const Icon(Icons.history, color: Colors.white),
                                          label: const Text('Registrar Treino Passado', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                                          onPressed: () async {
                                            await context.push('/past-workout-selector', extra: _selectedDay);
                                            store.loadHistory();
                                          },
                                        )
                                      ]
                                    ],
                                  ),
                                )
                              : ListView.builder(
                                  itemCount: selectedSessions.length,
                                  itemBuilder: (context, index) {
                                    final session = selectedSessions[index];
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
                                ),
                        ),
                      ],
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
