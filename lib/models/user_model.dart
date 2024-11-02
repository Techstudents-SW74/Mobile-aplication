class User {
  final String username;
  final String name;
  final String lastname;
  final String password;
  final String email;
  final String phone;
  final String birthDate;
  final String photo;
  final String role;
  final int restaurantId;

  User({
    required this.username,
    required this.name,
    required this.lastname,
    required this.password,
    required this.email,
    required this.phone,
    required this.birthDate,
    required this.photo,
    required this.role,
    required this.restaurantId,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      username: json['username'] ?? '', // Providing default values as safety
      name: json['name'] ?? '',
      lastname: json['lastname'] ?? '',
      password: json['password'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      birthDate: json['birthDate'] ?? '',
      photo: json['photo'] ?? '',
      role: json['role'] ?? '',
      restaurantId: json['restaurantId'] ?? 0,
    );
  }
}
