class ExerciseModel {
  final int? id;
  final String name;
  final String muscleGroup;
  final bool isCustom;

  ExerciseModel({
    this.id,
    required this.name,
    required this.muscleGroup,
    this.isCustom = false,
  });

  factory ExerciseModel.fromMap(Map<String, dynamic> map) {
    return ExerciseModel(
      id: map['id'],
      name: map['name'],
      muscleGroup: map['muscle_group'],
      isCustom: map['is_custom'] == 1,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'muscle_group': muscleGroup,
      'is_custom': isCustom ? 1 : 0,
    };
  }
}
