import 'package:sqflite/sqflite.dart';
import '../../../shared/models/user_profile_model.dart';
import '../../../core/database/database_helper.dart';

class AnalyticsRepository {
  final DatabaseHelper _dbHelper;

  AnalyticsRepository(this._dbHelper);

  Future<void> saveProfile(UserProfileModel profile) async {
    final db = await _dbHelper.database;
    // Em um app offline local, substituímos o antigo pelo novo
    await db.delete('user_profile');
    await db.insert('user_profile', profile.toMap());
  }

  Future<UserProfileModel?> getProfile() async {
    final db = await _dbHelper.database;
    final result = await db.query('user_profile', limit: 1);
    
    if (result.isNotEmpty) {
      return UserProfileModel.fromMap(result.first);
    }
    return null;
  }
}
