import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorgeHelper {
  final storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );

  Future saveToken(
    String accessToken,
    String name,
    String id,
    String role,
  ) async {
    await storage.write(key: "access_token", value: accessToken);
    await storage.write(key: "name", value: name);
    await storage.write(key: "id", value: id);
    await storage.write(key: "role", value: role);
  }

  Future<String?> getToken() async {
    return await storage.read(key: "access_token") ?? "";
  }

  Future<String?> getuserId() async {
    return await storage.read(key: "id") ?? "";
  }

  // Future<String?> getusername() async {
  //   return await storage.read(key: "username") ?? "";
  // }

  /// The user's display name (`users.name` — the "user" key written by
  /// [saveToken]), as opposed to [getusername], which is the login handle.
  Future<String?> getUserDisplayName() async {
    return await storage.read(key: "name") ?? "";
  }

  Future<String?> getrole() async {
    return await storage.read(key: "role") ?? "";
  }

  Future<String?> getunitId() async {
    return await storage.read(key: "unit") ?? "";
  }

  Future saveRememberedEmail(String email) async {
    await storage.write(key: "remembered_email", value: email);
  }

  Future<String?> getRememberedEmail() async {
    return await storage.read(key: "remembered_email");
  }

  Future clearRememberedEmail() async {
    await storage.delete(key: "remembered_email");
  }

  Future saveThemeMode(String mode) async {
    await storage.write(key: "theme_mode", value: mode);
  }

  Future<String?> getThemeMode() async {
    return await storage.read(key: "theme_mode");
  }

  Future deleteToken() async {
    await storage.delete(key: "access_token");
    await storage.delete(key: "name");
    await storage.delete(key: "id");
    await storage.delete(key: "role");
    await storage.delete(key: "unit");
  }
}
