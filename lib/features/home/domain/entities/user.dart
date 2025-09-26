// lib/features/home/domain/entities/user_entity.dart
class UserEntity {
  final String id;
  final String name;
  final String userName;
  final String number;
  final String upiID;
  final bool currentUser;

  const UserEntity({
    required this.id,
    required this.name,
    required this.userName,
    required this.number,
    required this.upiID,
    this.currentUser = false,
  });

  UserEntity copyWith({
    String? id,
    String? name,
    String? userName,
    String? number,
    String? upiID,
    bool? currentUser,
  }) {
    return UserEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      userName: userName ?? this.userName,
      number: number ?? this.number,
      upiID: upiID ?? this.upiID,
      currentUser: currentUser ?? this.currentUser,
    );
  }
}
