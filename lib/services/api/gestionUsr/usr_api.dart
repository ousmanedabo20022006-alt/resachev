import 'dart:convert';

import 'package:http/http.dart' as http;

import '../config.dart';
import 'gestion_token.dart';

class UsrApi {
  // ============================================================
  // CONNEXION
  // ============================================================

  // Permet de se connecter à l'API
  // et de demander l'envoi du code 2FA
  Future<Map<String, dynamic>?> loginUser(
      String mail,
      String paswd,
      ) async {
    // Construction de l'URL de l'API pour la connexion
    final url = Uri.parse(
      '${AppConfig.apiBaseUrl}/mobile/login',
    );

    try {
      // Envoi de la requête POST à l'API
      final response = await http
          .post(
        url,
        headers: <String, String>{
          'Content-Type':
          'application/json; charset=UTF-8',
          'Accept': 'application/json',
        },
        body: jsonEncode(<String, String>{
          'email': mail,
          'motpasse': paswd,
        }),
      )
          .timeout(
        const Duration(seconds: 45),
      );

      Map<String, dynamic>? data;

      if (response.body.isNotEmpty) {
        try {
          final decoded = jsonDecode(response.body);

          if (decoded is Map<String, dynamic>) {
            data = decoded;
          }
        } catch (_) {
          data = null;
        }
      }

      // ========================================================
      // Connexion réussie
      // ========================================================

      if (response.statusCode == 200) {
        if (data != null &&
            data['status'] == 'success') {
          return {
            'ok': true,
            'message':
            data['message'] ?? 'Connexion réussie',
            'user': data['data'],
          };
        }

        return {
          'ok': false,
          'message':
          data?['message'] ??
              'Réponse API invalide.',
          'user': null,
        };
      }

      // ========================================================
      // Identifiants incorrects
      // ========================================================

      if (response.statusCode == 401) {
        final backendMessage =
            data?['message'] ??
                data?['error'] ??
                data?['detail'] ??
                'Identifiants invalides ou accès non autorisé.';

        return {
          'ok': false,
          'message': backendMessage,
          'user': null,
        };
      }

      // ========================================================
      // Données incorrectes
      // ========================================================

      if (response.statusCode == 422) {
        return {
          'ok': false,
          'message':
          data?['message'] ??
              'Identifiants incorrects',
          'user': null,
        };
      }

      // ========================================================
      // Autre erreur serveur
      // ========================================================

      return {
        'ok': false,
        'message':
        data?['message'] ??
            'Erreur serveur (${response.statusCode})',
        'user': null,
      };
    } catch (e) {
      return {
        'ok': false,
        'message':
        'Erreur inattendue pendant la connexion API.',
        'user': null,
      };
    }
  }

  // ============================================================
  // VERIFICATION DU CODE 2FA
  // ============================================================

  Future<Map<String, dynamic>?> verify2FA(
      String email,
      String code,
      ) async {
    final url = Uri.parse(
      '${AppConfig.apiBaseUrl}/mobile/verify-2fa',
    );

    try {
      final response = await http
          .post(
        url,
        headers: <String, String>{
          'Content-Type':
          'application/json; charset=UTF-8',
          'Accept': 'application/json',
        },
        body: jsonEncode(<String, String>{
          'email': email,
          'code': code,
        }),
      )
          .timeout(
        const Duration(seconds: 45),
      );

      Map<String, dynamic>? data;

      if (response.body.isNotEmpty) {
        try {
          final decoded = jsonDecode(response.body);

          if (decoded is Map<String, dynamic>) {
            data = decoded;
          }
        } catch (_) {
          data = null;
        }
      }

      // ========================================================
      // Code 2FA valide
      // ========================================================

      if (response.statusCode == 200) {
        final token = data?['token'];

        // Sauvegarde du token
        if (token != null &&
            token.toString().isNotEmpty) {
          await GestionToken.saveToken(
            token.toString(),
          );
        }

        return {
          'ok': true,
          'message': 'Code 2FA valide.',
          'token': token,
          'user': data?['utilisateur'],
        };
      }

      // ========================================================
      // Code 2FA invalide ou expiré
      // ========================================================

      if (response.statusCode == 401) {
        return {
          'ok': false,
          'message':
          data?['message'] ??
              'Code invalide ou expiré.',
          'token': null,
          'user': null,
        };
      }

      // ========================================================
      // Données manquantes ou invalides
      // ========================================================

      if (response.statusCode == 422) {
        return {
          'ok': false,
          'message':
          data?['message'] ??
              'Données manquantes ou invalides.',
          'token': null,
          'user': null,
        };
      }

      // ========================================================
      // Autre erreur serveur
      // ========================================================

      return {
        'ok': false,
        'message':
        data?['message'] ??
            'Erreur serveur (${response.statusCode})',
        'token': null,
        'user': null,
      };
    } catch (e) {
      return {
        'ok': false,
        'message':
        'Erreur inattendue pendant la vérification 2FA.',
        'token': null,
        'user': null,
      };
    }
  }

  // ============================================================
  // RECUPERATION DE L'UTILISATEUR CONNECTE
  // ============================================================

  Future<Map<String, dynamic>?> getMe() async {
    // Récupération du token enregistré
    final token = await GestionToken.getToken();

    // Si aucun token n'est présent
    if (token == null || token.isEmpty) {
      return {
        'ok': false,
        'message': 'Utilisateur non connecté.',
        'user': null,
      };
    }

    // URL de l'API
    final url = Uri.parse(
      '${AppConfig.apiBaseUrl}/mobile/me',
    );

    try {
      // Appel GET avec le token
      final response = await http
          .get(
        url,
        headers: <String, String>{
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      )
          .timeout(
        const Duration(seconds: 45),
      );

      Map<String, dynamic>? data;

      // Lecture de la réponse JSON
      if (response.body.isNotEmpty) {
        try {
          final decoded = jsonDecode(response.body);

          if (decoded is Map<String, dynamic>) {
            data = decoded;
          }
        } catch (_) {
          data = null;
        }
      }

      // ========================================================
      // Informations récupérées
      // ========================================================

      if (response.statusCode == 200) {
        return {
          'ok': true,
          'message': 'Informations récupérées.',
          'user': data?['utilisateur'] ?? data,
        };
      }

      // ========================================================
      // Token invalide ou expiré
      // ========================================================

      if (response.statusCode == 401) {
        return {
          'ok': false,
          'message':
          data?['message'] ??
              'Token invalide ou expiré.',
          'user': null,
        };
      }

      // ========================================================
      // Autre erreur serveur
      // ========================================================

      return {
        'ok': false,
        'message':
        data?['message'] ??
            'Erreur serveur (${response.statusCode})',
        'user': null,
      };
    } catch (e) {
      return {
        'ok': false,
        'message':
        'Erreur inattendue pendant la récupération du profil.',
        'user': null,
      };
    }
  }
}