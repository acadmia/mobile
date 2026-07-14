import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sqflite/sqflite.dart';
import 'package:mobile/features/catalog/data/catalog_repository.dart';
import 'package:mobile/shared/models/exercise_model.dart';
import 'package:mobile/core/database/database_helper.dart';

class MockDatabaseHelper extends Mock implements DatabaseHelper {}
class MockDatabase extends Mock implements Database {}

void main() {
  late CatalogRepository repository;
  late MockDatabaseHelper mockDbHelper;
  late MockDatabase mockDb;

  setUp(() {
    mockDbHelper = MockDatabaseHelper();
    mockDb = MockDatabase();
    
    // Simula a abertura do banco de dados
    when(() => mockDbHelper.database).thenAnswer((_) async => mockDb);
    repository = CatalogRepository(mockDbHelper);
  });

  test('Deve buscar todos os exercicios e retornar a lista de models', () async {
    when(() => mockDb.query('exercises', orderBy: 'name ASC'))
        .thenAnswer((_) async => [
              {'id': 1, 'name': 'Supino', 'muscle_group': 'Peito', 'is_custom': 0}
            ]);

    final result = await repository.getAllExercises();

    expect(result.length, 1);
    expect(result.first.name, 'Supino');
    verify(() => mockDb.query('exercises', orderBy: 'name ASC')).called(1);
  });

  test('Deve salvar um exercicio customizado no banco', () async {
    final exercise = ExerciseModel(name: 'Teste', muscleGroup: 'Pernas', isCustom: true);
    
    when(() => mockDb.insert('exercises', exercise.toMap())).thenAnswer((_) async => 1);

    final id = await repository.saveCustomExercise(exercise);

    expect(id, 1);
    verify(() => mockDb.insert('exercises', exercise.toMap())).called(1);
  });
}
