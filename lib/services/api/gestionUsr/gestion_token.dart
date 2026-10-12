import 'package:shared_preferences/shared_preferences.dart';

class GestionToken {
  // Permet de récupérer le token de l'utilisateur
  // et de le sauvegarder dans les préférences partagées.
  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  // Permet de savoir si l'utilisateur est connecté
  // en vérifiant si le token existe.
  static Future<bool> isLogged() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token') != null;
  }

  // Permet de se déconnecter de l'utilisateur
  // en supprimant le token.
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
  }

  // Permet de récupérer le token de l'utilisateur.
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }
}