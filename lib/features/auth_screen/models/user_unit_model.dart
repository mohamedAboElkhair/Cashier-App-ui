class UserUnitModel {
  final String full_name;
  final String email;
  final String password;
  final String role;
  final String address;
  final String active;
  final String id_number;
  final String mobile_phone;
  final String nationality;
  final int buildingid;
  final int property_id;
  final int floorid;
  final int unitid;
  String accessToken;
  String? tokenType;
  int? expiresIn;
  String? user;
  String? username;
  int? user_id;

  UserUnitModel({
    required this.full_name,
    required this.email,
    required this.password,
    required this.role,
    required this.address,
    required this.active,
    required this.id_number,
    required this.mobile_phone,
    required this.nationality,
    required this.buildingid,
    required this.property_id,
    required this.floorid,
    required this.unitid,
    required this.accessToken,
    this.tokenType,
    this.expiresIn,
    this.user,
    this.username,
    this.user_id,
  });
  factory UserUnitModel.fromJson(Map<String, dynamic> json) {
    return UserUnitModel(
      full_name: json['full_name'] ?? '',
      email: json['email'] ?? '',
      password: json['password'] ?? '',
      role: json['role'] ?? '',
      address: json['address'] ?? '',
      active: json['active'] ?? '',
      id_number: json['id_number'] ?? '',
      mobile_phone: json['mobile_phone'] ?? '',
      nationality: json['nationality'] ?? '',
      buildingid: json['buildingid'] ?? 0,
      property_id: json['property_id'] ?? 0,
      floorid: json['floorid'] ?? 0,
      unitid: json['unitid'] ?? 0,
      accessToken: json['access_token'] ?? '',
      tokenType: json['token_type'],
      expiresIn: json['expires_in'],
      user: json['user'],
      username: json['username'],
      user_id: json['user_id'],
    );
  }
}
