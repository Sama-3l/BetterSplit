// lib/features/home/data/models/user_model.dart
import 'package:bettersplitapp/features/home/domain/entities/user.dart';
import 'package:hive/hive.dart';

part 'user_model_local.g.dart';

@HiveType(typeId: 0)
class UserModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String userName;

  @HiveField(3)
  String number;

  @HiveField(4)
  String upiID;

  @HiveField(5)
  bool currentUser;

  UserModel({
    required this.id,
    required this.name,
    required this.userName,
    required this.number,
    required this.upiID,
    this.currentUser = false,
  });

  /// Convert Model → Entity
  UserEntity toEntity() {
    return UserEntity(
      id: id,
      name: name,
      userName: userName,
      number: number,
      upiID: upiID,
      currentUser: currentUser,
    );
  }

  /// Create Model from Entity
  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
      id: entity.id,
      name: entity.name,
      userName: entity.userName,
      number: entity.number,
      upiID: entity.upiID,
      currentUser: entity.currentUser,
    );
  }

  /// From JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      userName: json['userName'] ?? '',
      number: json['number'] ?? '',
      upiID: json['upiID'] ?? '',
      currentUser: json['currentUser'] ?? false,
    );
  }

  /// To JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'userName': userName,
      'number': number,
      'upiID': upiID,
      'currentUser': currentUser,
    };
  }

  Future openBox() async {}
}
