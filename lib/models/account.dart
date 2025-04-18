class Account {
  final int accountId;
  final String username;
  final String password;
  final String email;
  final String fullName;
  final bool isAdmin;
  final DateTime createdAt;

  Account({
    required this.accountId,
    required this.username,
    required this.password,
    required this.email,
    required this.fullName,
    required this.isAdmin,
    required this.createdAt,
  });

  // Convert JSON to Account
  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      accountId: json['accountId'],
      username: json['username'],
      password: json['password'],
      email: json['email'],
      fullName: json['fullName'],
      isAdmin: json['isAdmin'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  // Convert Account to JSON
  Map<String, dynamic> toJson() {
    return {
      'accountId': accountId,
      'username': username,
      'password': password,
      'email': email,
      'fullName': fullName,
      'isAdmin': isAdmin,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
