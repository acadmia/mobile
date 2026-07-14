import 'package:sqflite/sqflite.dart';
import '../../../shared/models/history_session_model.dart';
import '../../../core/database/database_helper.dart';

class HistoryRepository {
  final DatabaseHelper _dbHelper;

  HistoryRepository(this._dbHelper);

  Future<List<HistorySessionModel>> getSessionsHistory() async {
    final db = await _dbHelper.database;
    
    // JOIN avançado que mistura a tabela de Sessões com a Tabela de Nomes dos Treinos,
    // usando uma Subquery para contar quantas Séries o usuário realmente executou naquela data.
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT 
        ws.id as session_id, 
        wt.name as template_name, 
        ws.start_time, 
        ws.end_time,
        (SELECT COUNT(id) FROM workout_sets WHERE session_id = ws.id) as total_sets,
        ws.total_volume
      FROM workout_sessions ws
      LEFT JOIN workout_templates wt ON ws.template_id = wt.id
      ORDER BY ws.start_time DESC
    ''');

    return maps.map((map) => HistorySessionModel.fromMap(map)).toList();
  }
}
