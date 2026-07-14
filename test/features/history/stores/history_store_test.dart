import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mobile/features/history/stores/history_store.dart';
import 'package:mobile/features/history/data/history_repository.dart';
import 'package:mobile/shared/models/history_session_model.dart';

class MockHistoryRepository extends Mock implements HistoryRepository {}

void main() {
  late HistoryStore store;
  late MockHistoryRepository mockRepository;

  setUp(() {
    mockRepository = MockHistoryRepository();
    store = HistoryStore(mockRepository);
  });

  test('Deve emitir Data ao carregar o historico com sucesso', () async {
    final mockData = [
      HistorySessionModel(
        sessionId: 1, 
        templateName: 'Biceps', 
        startTime: DateTime.now(), 
        totalSets: 5, 
        totalVolume: 0
      )
    ];
    
    when(() => mockRepository.getSessionsHistory()).thenAnswer((_) async => mockData);

    await store.loadHistory();

    expect(store.state.length, 1);
    expect(store.state.first.templateName, 'Biceps');
    verify(() => mockRepository.getSessionsHistory()).called(1);
  });
}
