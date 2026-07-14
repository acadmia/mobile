class HealthCalculatorService {
  
  // Utiliza a fórmula matemática de Keytel (2005) para achar o gasto calórico preciso
  static double calculateCalories({
    required String gender, 
    required int age, 
    required double weightKg, 
    required double avgHeartRate, 
    required double timeInHours,
  }) {
    double caloriesPerMinute;
    
    if (gender.toUpperCase() == 'M') {
      caloriesPerMinute = (-55.0969 + (0.6309 * avgHeartRate) + (0.1988 * weightKg) + (0.2017 * age)) / 4.184;
    } else {
      caloriesPerMinute = (-20.4022 + (0.4472 * avgHeartRate) - (0.1263 * weightKg) + (0.074 * age)) / 4.184;
    }

    if (caloriesPerMinute < 0) caloriesPerMinute = 0; 
    
    final totalMinutes = timeInHours * 60;
    return caloriesPerMinute * totalMinutes;
  }

  // Utiliza a fórmula clássica de Tanaka (2001) para Frequência Cardíaca Máxima
  static double calculateMaxHeartRate(int age) {
    return 208 - (0.7 * age);
  }
}
