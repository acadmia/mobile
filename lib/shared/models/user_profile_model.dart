class UserProfileModel {
  final int? id;
  final int age;
  final double weight;
  final double height;
  final String gender; 
  final double heartRate; 

  UserProfileModel({
    this.id,
    required this.age,
    required this.weight,
    required this.height,
    required this.gender,
    required this.heartRate,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'age': age,
      'weight': weight,
      'height': height,
      'gender': gender,
      'heart_rate': heartRate,
    };
  }

  factory UserProfileModel.fromMap(Map<String, dynamic> map) {
    return UserProfileModel(
      id: map['id'],
      age: map['age'],
      weight: (map['weight'] as num).toDouble(),
      height: (map['height'] as num).toDouble(),
      gender: map['gender'],
      heartRate: (map['heart_rate'] as num).toDouble(),
    );
  }
}
