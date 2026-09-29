// To parse this JSON data, do
//
//     final loginResponseModel = loginResponseModelFromJson(jsonString);

import 'dart:convert';

LoginResponseModel loginResponseModelFromJson(str) =>
    LoginResponseModel.fromJson(str);

String loginResponseModelToJson(LoginResponseModel data) =>
    json.encode(data.toJson());

class LoginResponseModel {
  String accessToken;
  String? tokenType;
  int? expiresIn;
  String? name;
  int? id;
  String? role;

  // Terms re-agree gate (Task 13). The backend now also reports whether the
  // user must re-agree to updated property terms before entering the app,
  // plus the active terms' `sections` list and — defensively — the property id
  // and version needed to POST the consent back. `active_terms` is documented
  // as just the sections list; property_id/version are parsed from wherever the
  // backend happens to send them (top level, or nested on an active_terms map).
  bool termsReagreeRequired;
  List<dynamic>? activeTerms;
  int? propertyId;
  int? termsVersion;

  LoginResponseModel({
    required this.accessToken,
    this.tokenType,
    this.expiresIn,
    this.name,
    this.role,
    this.termsReagreeRequired = false,
    this.activeTerms,
    this.propertyId,
    this.termsVersion,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    final rawActiveTerms = json["active_terms"];
    final activeTermsMap = rawActiveTerms is Map ? rawActiveTerms : null;
    return LoginResponseModel(
      accessToken: json["access_token"],
      tokenType: json["token_type"],
      expiresIn: json["expires_in"],
      name: json["name"],
      role: json["role"],
      termsReagreeRequired: _asBool(json["terms_reagree_required"]),
      activeTerms: rawActiveTerms is List
          ? rawActiveTerms
          : (activeTermsMap?["sections"] is List
                ? activeTermsMap!["sections"] as List
                : null),
      propertyId: _asInt(json["property_id"] ?? activeTermsMap?["property_id"]),
      termsVersion: _asInt(json["terms_version"] ?? activeTermsMap?["version"]),
    );
  }

  Map<String, dynamic> toJson() => {
    "access_token": accessToken,
    "token_type": tokenType,
    "expires_in": expiresIn,
    "name": name,
    "id": id,
    "role": role,
    "terms_reagree_required": termsReagreeRequired,
    "active_terms": activeTerms,
    "terms_version": termsVersion,
  };
}

bool _asBool(dynamic v) {
  if (v is bool) return v;
  if (v is num) return v != 0;
  final s = v?.toString().trim().toLowerCase();
  return s == '1' || s == 'true' || s == 'yes';
}

int? _asInt(dynamic v) {
  if (v is int) return v;
  if (v is num) return v.toInt();
  if (v is String) return int.tryParse(v.trim());
  return null;
}
