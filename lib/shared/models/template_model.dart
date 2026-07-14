import 'exercise_model.dart';

class TemplateModel {
  final int? id;
  final String name;
  final List<ExerciseModel> exercises; 

  TemplateModel({
    this.id,
    required this.name,
    this.exercises = const [],
  });

  factory TemplateModel.fromMap(Map<String, dynamic> map, {List<ExerciseModel> exercises = const []}) {
    return TemplateModel(
      id: map['id'],
      name: map['name'],
      exercises: exercises,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }
}
