import 'package:flutter_triple/flutter_triple.dart';
import '../../../shared/models/history_session_model.dart';
import '../data/history_repository.dart';

class HistoryStore extends Store<List<HistorySessionModel>> {
  final HistoryRepository _repository;

  HistoryStore(this._repository) : super([]);

  Future<void> loadHistory() async {
    setLoading(true);
    try {
      final sessions = await _repository.getSessionsHistory();
      update(sessions);
    } catch (e) {
      setError(e);
    } finally {
      setLoading(false);
    }
  }
}
