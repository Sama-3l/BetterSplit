import 'package:bettersplitapp/features/home/domain/models/local/user_model_local.dart';
import 'package:hive/hive.dart';

abstract class UserLocalDataSource {
  Future<void> saveUser(UserModel user);
  Future<UserModel?> getCurrentUser();
  Future<UserModel?> getUserByNumber(String phoneNumber);
  Future<List<UserModel>> getAllUsers();
  Future<void> deleteAllUsers();
}

class UserLocalDataSourceImpl implements UserLocalDataSource {
  static const _userBoxName = 'userBox';

  @override
  Future<void> saveUser(UserModel user) async {
    final box = await Hive.openBox<UserModel>(_userBoxName);
    await box.put(user.id, user);
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    final box = await Hive.openBox<UserModel>(_userBoxName);
    try {
      return box.values.firstWhere((u) => u.currentUser == true);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<List<UserModel>> getAllUsers() async {
    final box = await Hive.openBox<UserModel>(_userBoxName);
    try {
      return box.values.toList();
    } catch (_) {
      return [];
    }
  }

  @override
  Future<void> deleteAllUsers() async {
    final box = await Hive.openBox<UserModel>(_userBoxName);
    try {
      box.clear();
    } catch (_) {}
  }

  @override
  Future<UserModel?> getUserByNumber(String phoneNumber) async {
    final box = await Hive.openBox<UserModel>(_userBoxName);
    try {
      return box.values.firstWhere((u) => u.number == phoneNumber);
    } catch (_) {
      return null;
    }
  }
}
