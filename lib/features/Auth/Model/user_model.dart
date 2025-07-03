class UserModel {
  String? id;
  String? name;
  String? email;
  String? password;
  String? token;
  String? profilePic;
  String? gender;
  String? phoneNumber;
  String? dateOfBirth;
  bool? isOnline;
  String? lastActive;
  String? pushToken;
  String? createdAt;

  UserModel({
    this.id = '',
    this.name = '',
    this.email = '',
    this.password = '',
    this.profilePic = '',
    this.gender = '',
    this.phoneNumber = '',
    this.dateOfBirth = '',
    this.isOnline = false,
    this.lastActive = '',
    this.pushToken = '',
    this.token = '',
    String? createdAt,
  }) : createdAt =
            createdAt ?? DateTime.now().millisecondsSinceEpoch.toString();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
      'profilePic': profilePic,
      'gender': gender,
      'token': token,
      'phoneNumber': phoneNumber,
      'dateOfBirth': dateOfBirth,
      'isOnline': isOnline,
      'lastActive': lastActive,
      'pushToken': pushToken,
      'createdAt': createdAt,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      password: map['password'] ?? '',
      profilePic: map['profilePic'] ?? '',
      gender: map['gender'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      dateOfBirth: map['dateOfBirth'] ?? '',
      isOnline: map['isOnline'] ?? false,
      lastActive: map['lastActive'] as String? ?? '',
      pushToken: map['pushToken'] ?? '',
      token: map['token'] ?? '',
      createdAt:
          map['createdAt'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
    );
  }
}
