import 'package:flutter_triple/flutter_triple.dart';
import '../../../shared/models/template_model.dart';
import '../data/template_repository.dart';

class TemplateListStore extends Store<List<TemplateModel>> {
  final TemplateRepository _repository;

  TemplateListStore(this._repository) : super([]);

  Future<void> loadTemplates() async {
    setLoading(true);
    try {
      final templates = await _repository.getAllTemplates();
      update(templates);
    } catch (e) {
      setError(e);
    } finally {
      setLoading(false);
    }
  }
}
