class UserAccountModel {
  final String? username;
  final String? name;
  final int? userId;
  final String? role;
  final String? email;
  final String? active;

  UserAccountModel({
    this.username,
    this.name,
    this.userId,
    this.role,
    this.email,
    this.active,
  });

  factory UserAccountModel.fromJson(Map<String, dynamic> json) {
    // Try multiple common shapes
    final Map<String, dynamic> root = json;
    Map<String, dynamic> source = root;
    if (root['data'] is Map<String, dynamic>) {
      source = root['data'] as Map<String, dynamic>;
    }
    if (root['user'] is Map<String, dynamic>) {
      source = root['user'] as Map<String, dynamic>;
    }

    String? username =
        source['username'] ??
        root['username'] ??
        source['name'] ??
        root['name'];
    int? userId;
    final dynamic uid =
        source['user_id'] ?? root['user_id'] ?? source['id'] ?? root['id'];
    if (uid is int) {
      userId = uid;
    } else if (uid is String) {
      userId = int.tryParse(uid);
    }
    String? role = source['role'] ?? root['role'];
    String? email = source['email'] ?? root['email'];

    return UserAccountModel(
      username: username,
      name: source['name'] ?? root['name'],
      userId: userId,
      role: role,
      email: email,
      active: source['active'] ?? root['active'],
    );
  }
}
