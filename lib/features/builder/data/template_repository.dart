import 'package:sqflite/sqflite.dart';
import '../../../shared/models/template_model.dart';
import '../../../shared/models/exercise_model.dart';
import '../../../core/database/database_helper.dart';

class TemplateRepository {
  final DatabaseHelper _dbHelper;

  TemplateRepository(this._dbHelper);

  Future<int> saveTemplate(TemplateModel template) async {
    final db = await _dbHelper.database;
    int templateId = 0;
    
    // Executa uma transação: ou salva tudo (template + exercicios), ou não salva nada (evita dados corrompidos)
    await db.transaction((txn) async {
      templateId = await txn.insert('workout_templates', template.toMap());
      
      for (int i = 0; i < template.exercises.length; i++) {
        await txn.insert('template_exercises', {
          'template_id': templateId,
          'exercise_id': template.exercises[i].id,
          'sort_order': i,
        });
      }
    });
    
    return templateId;
  }

  Future<List<TemplateModel>> getAllTemplates() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> templateMaps = await db.query('workout_templates');
    
    List<TemplateModel> templates = [];
    
    for (var map in templateMaps) {
      final templateId = map['id'] as int;
      
      // Busca os exercícios atrelados a esse template usando JOIN, garantindo a ordem salva (sort_order)
      final List<Map<String, dynamic>> exMaps = await db.rawQuery('''
        SELECT e.* FROM exercises e
        INNER JOIN template_exercises te ON e.id = te.exercise_id
        WHERE te.template_id = ?
        ORDER BY te.sort_order ASC
      ''', [templateId]);
      
      final exercises = exMaps.map((e) => ExerciseModel.fromMap(e)).toList();
      templates.add(TemplateModel.fromMap(map, exercises: exercises));
    }
    
    return templates;
  }
}
