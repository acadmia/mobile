import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sqflite/sqflite.dart';
import 'package:mobile/features/builder/data/template_repository.dart';
import 'package:mobile/core/database/database_helper.dart';

class MockDatabaseHelper extends Mock implements DatabaseHelper {}
class MockDatabase extends Mock implements Database {}

void main() {
  late TemplateRepository repository;
  late MockDatabaseHelper mockDbHelper;
  late MockDatabase mockDb;

  setUp(() {
    mockDbHelper = MockDatabaseHelper();
    mockDb = MockDatabase();
    when(() => mockDbHelper.database).thenAnswer((_) async => mockDb);
    repository = TemplateRepository(mockDbHelper);
  });

  test('Deve buscar os templates e agrupar com seus respectivos exercicios', () async {
    when(() => mockDb.query('workout_templates'))
        .thenAnswer((_) async => [{'id': 1, 'name': 'Treino A'}]);
        
    when(() => mockDb.rawQuery(any(), [1]))
        .thenAnswer((_) async => [{'id': 9, 'name': 'Supino', 'muscle_group': 'Peito', 'is_custom': 0}]);

    final result = await repository.getAllTemplates();

    expect(result.length, 1);
    expect(result.first.name, 'Treino A');
    expect(result.first.exercises.length, 1);
    expect(result.first.exercises.first.name, 'Supino');
  });
}
