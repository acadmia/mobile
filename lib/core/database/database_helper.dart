import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  // Padrão Singleton: Garante que só tenhamos uma única conexão aberta com o banco
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
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // 1. Cria a Tabela de Exercícios
    await db.execute('''
      CREATE TABLE exercises (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        muscle_group TEXT NOT NULL,
        is_custom INTEGER DEFAULT 0
      )
    ''');
    
    // 2. Faz o Seeding (Popula o banco com os 98 exercícios na primeira abertura)
    await _seedDatabase(db);
  }

  Future<void> _seedDatabase(Database db) async {
    try {
      // Lê o JSON silenciosamente dos arquivos internos do App
      final String jsonString = await rootBundle.loadString('assets/exercicios_seed.json');
      final List<dynamic> jsonList = jsonDecode(jsonString);

      // Usamos o "Batch" para fazer várias inserções de uma só vez (muito mais rápido)
      Batch batch = db.batch();
      for (var item in jsonList) {
        batch.insert('exercises', {
          // Aceitando variações nas chaves do JSON para garantir que não quebre
          'name': item['nome'] ?? item['name'] ?? 'Exercício Desconhecido',
          'muscle_group': item['grupoMuscular'] ?? item['muscleGroup'] ?? item['muscle_group'] ?? 'Geral',
          'is_custom': 0, // 0 = false no SQLite
        });
      }
      await batch.commit(noResult: true);
    } catch (e) {
      print('Erro crítico ao fazer o seed do JSON: \$e');
    }
  }
}
