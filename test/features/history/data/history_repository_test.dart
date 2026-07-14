import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sqflite/sqflite.dart';
import 'package:mobile/features/history/data/history_repository.dart';
import 'package:mobile/core/database/database_helper.dart';

class MockDatabaseHelper extends Mock implements DatabaseHelper {}
class MockDatabase extends Mock implements Database {}

void main() {
  late HistoryRepository repository;
  late MockDatabaseHelper mockDbHelper;
  late MockDatabase mockDb;

  setUp(() {
    mockDbHelper = MockDatabaseHelper();
    mockDb = MockDatabase();
    when(() => mockDbHelper.database).thenAnswer((_) async => mockDb);
    repository = HistoryRepository(mockDbHelper);
  });

  test('Deve buscar o historico de sessoes agregando as informacoes de nome e total de series', () async {
    when(() => mockDb.rawQuery(any())).thenAnswer((_) async => [
      {
        'session_id': 1,
        'template_name': 'Treino A',
        'start_time': '2023-10-10T10:00:00.000',
        'total_sets': 15,
        'total_volume': 1500.0
      }
    ]);

    final result = await repository.getSessionsHistory();

    expect(result.length, 1);
    expect(result.first.templateName, 'Treino A');
    expect(result.first.totalSets, 15);
    verify(() => mockDb.rawQuery(any())).called(1);
  });
}
