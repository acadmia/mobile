import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/features/analytics/services/health_calculator_service.dart';

void main() {
  group('Inteligencia Biomedica (HealthCalculatorService)', () {
    test('A formula de Keytel deve calcular calorias consistentes para perfil Masculino', () {
      final calories = HealthCalculatorService.calculateCalories(
        gender: 'M', 
        age: 25, 
        weightKg: 80, 
        avgHeartRate: 140, 
        timeInHours: 1.0, 
      );
      
      expect(calories, greaterThan(400));
      expect(calories, lessThan(850));
    });

    test('A formula de Keytel deve calcular calorias consistentes para perfil Feminino', () {
      final calories = HealthCalculatorService.calculateCalories(
        gender: 'F', 
        age: 25, 
        weightKg: 65, 
        avgHeartRate: 140, 
        timeInHours: 1.0,
      );
      
      expect(calories, greaterThan(300));
      expect(calories, lessThan(600));
    });

    test('A formula de Tanaka deve retornar a Frequencia Maxima baseada na idade rigorosamente', () {
      final maxHr = HealthCalculatorService.calculateMaxHeartRate(30);
      expect(maxHr, 187.0);
    });
  });
}
