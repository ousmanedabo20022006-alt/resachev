import 'package:flutter/material.dart';

import '../services/api/gestionUsr/usr_api.dart';

class Authentification extends StatefulWidget {
  final String email;

  const Authentification({
    super.key,
    required this.email,
  });

  @override
  State<Authentification> createState() =>
      _AuthentificationState();
}

class _AuthentificationState extends State<Authentification> {
  final List<TextEditingController> controllers =
  List.generate(6, (_) => TextEditingController());

  final List<FocusNode> focusNodes =
  List.generate(6, (_) => FocusNode());

  bool chargement = false;

  // ============================================================
  // VERIFICATION DU CODE
  // ============================================================

  Future<void> _verifierCode() async {
    final String code = controllers
        .map((controller) => controller.text)
        .join();

    if (code.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Veuillez saisir les 6 chiffres du code.',
          ),
        ),
      );
      return;
    }

    setState(() {
      chargement = true;
    });

    final result = await UsrApi().verify2FA(
      widget.email,
      code,
    );

    if (!mounted) return;

    setState(() {
      chargement = false;
    });

    final String message =
        result?['message']?.toString() ?? '';

    if (result != null && result['ok'] == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Authentification réussie.'),
        ),
      );

      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            message.isNotEmpty
                ? message
                : 'Code invalide ou expiré.',
          ),
        ),
      );

      for (final controller in controllers) {
        controller.clear();
      }

      focusNodes[0].requestFocus();
    }
  }

  // ============================================================
  // LIBERATION DES RESSOURCES
  // ============================================================

  @override
  void dispose() {
    for (final controller in controllers) {
      controller.dispose();
    }

    for (final node in focusNodes) {
      node.dispose();
    }

    super.dispose();
  }

  // ============================================================
  // INTERFACE
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Authentification',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),

      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),

          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),

            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: Colors.grey,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(10),
            ),

            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Titre sans icône
                const Text(
                  'Vérification de votre identité',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 12),

                // Adresse e-mail
                Text(
                  'Saisissez le code à 6 chiffres envoyé à '
                      '${widget.email}.',
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 24),

                // Six cases rapprochées
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(6, (index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 3,
                      ),
                      child: SizedBox(
                        width: 38,
                        child: TextField(
                          controller: controllers[index],
                          focusNode: focusNodes[index],
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          maxLength: 1,

                          decoration: const InputDecoration(
                            counterText: '',
                            isDense: true,
                            contentPadding:
                            EdgeInsets.symmetric(
                              vertical: 12,
                            ),
                            border: OutlineInputBorder(),
                          ),

                          onChanged: (value) {
                            if (value.isNotEmpty &&
                                index < 5) {
                              focusNodes[index + 1]
                                  .requestFocus();
                            } else if (value.isEmpty &&
                                index > 0) {
                              focusNodes[index - 1]
                                  .requestFocus();
                            }
                          },
                        ),
                      ),
                    );
                  }),
                ),

                const SizedBox(height: 24),

                // Bouton avec son propre cadre
                Center(
                  child: ElevatedButton(
                    onPressed:
                    chargement ? null : _verifierCode,

                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 14,
                      ),
                    ),

                    child: chargement
                        ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                    )
                        : const Text(
                      'Valider le code',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}