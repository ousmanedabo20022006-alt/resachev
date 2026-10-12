import 'package:flutter/material.dart';
import '../utils/theme_controller.dart';

class Parametres extends StatelessWidget {
  final ThemeController themeController;

  const Parametres({
    super.key,
    required this.themeController,
  });

  @override
  Widget build(BuildContext context) {
    final bool modeSombre =
        themeController.themeMode == ThemeMode.dark;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Cadre orange complet avec ResaChev client au centre
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: Colors.orange,
            child: const Center(
              child: Text(
                'ResaChev client',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),

          const SizedBox(height: 25),

          // Gestion des paramètres
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.08),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              "Gestion des paramètres de l'application",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Mode sombre / clair
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.08),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  modeSombre
                      ? 'Passer en mode clair'
                      : 'Passer en mode sombre',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 5),

                // Bouton à gauche
                Align(
                  alignment: Alignment.centerLeft,
                  child: Switch(
                    value: modeSombre,
                    onChanged: (value) {
                      themeController.toggleTheme();
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}