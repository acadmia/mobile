import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mobile/features/builder/stores/template_list_store.dart';
import 'package:mobile/features/builder/data/template_repository.dart';
import 'package:mobile/shared/models/template_model.dart';

class MockTemplateRepository extends Mock implements TemplateRepository {}

void main() {
  late TemplateListStore store;
  late MockTemplateRepository mockRepository;

  setUp(() {
    mockRepository = MockTemplateRepository();
    store = TemplateListStore(mockRepository);
  });

  test('Deve atualizar o state ao carregar templates com sucesso', () async {
    final mockData = [TemplateModel(name: 'Treino A')];
    when(() => mockRepository.getAllTemplates()).thenAnswer((_) async => mockData);

    await store.loadTemplates();

    expect(store.state.length, 1);
    expect(store.state.first.name, 'Treino A');
  });
}
