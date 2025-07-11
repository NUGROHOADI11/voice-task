import 'package:hive_ce/hive.dart';

import '../constants/landing_api_constant.dart';
import '../models/user_model.dart';

class LandingRepository {
  LandingRepository._internal();

  var apiConstant = LandingApiConstant();
  static final LandingRepository _instance = LandingRepository._internal();
  factory LandingRepository() => _instance;

  final Box<UserModel> _userBox = Hive.box<UserModel>('userProfile');
  static const String _userKey = 'currentUser';

  Future<void> saveUserProfile(UserModel user) async {
    await _userBox.put(_userKey, user);
  }

  Future<void> deleteUserProfile() async {
    await _userBox.clear();
  }

  UserModel? getUserProfile() {
    return _userBox.get(_userKey);
  }
}
