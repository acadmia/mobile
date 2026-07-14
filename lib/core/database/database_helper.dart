import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'bordo_gym.db');

    return await openDatabase(
      path,
      version: 1,
      // Habilita as Chaves Estrangeiras (Foreign Keys) para exclusão em cascata
      onConfigure: (db) async => await db.execute('PRAGMA foreign_keys = ON'),
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE exercises (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        muscle_group TEXT NOT NULL,
        is_custom INTEGER DEFAULT 0
      )
    ''');

    await db.execute('''
      CREATE TABLE workout_templates (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE template_exercises (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        template_id INTEGER NOT NULL,
        exercise_id INTEGER NOT NULL,
        sort_order INTEGER NOT NULL,
        FOREIGN KEY (template_id) REFERENCES workout_templates (id) ON DELETE CASCADE,
        FOREIGN KEY (exercise_id) REFERENCES exercises (id) ON DELETE CASCADE
      )
    ''');
    
    await _seedDatabase(db);
  }

  Future<void> _seedDatabase(Database db) async {
    try {
      final String jsonString = await rootBundle.loadString('assets/exercicios_seed.json');
      final List<dynamic> jsonList = jsonDecode(jsonString);

      Batch batch = db.batch();
      for (var item in jsonList) {
        batch.insert('exercises', {
          'name': item['nome'] ?? item['name'] ?? 'Exercício Desconhecido',
          'muscle_group': item['grupoMuscular'] ?? item['muscleGroup'] ?? item['muscle_group'] ?? 'Geral',
          'is_custom': 0,
        });
      }
      await batch.commit(noResult: true);
    } catch (e) {
      print('Erro crítico ao fazer o seed do JSON: \$e');
    }
  }
}
