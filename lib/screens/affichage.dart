import 'package:flutter/material.dart';
import '../widgets/appbar.dart';
import '../widgets/my_flutter_app_icons.dart';
import '../utils/theme_controller.dart';
import 'accueil.dart';
import 'parametres.dart';
import 'connexion.dart';

class Affichage extends StatefulWidget {
  final ThemeController themeController;

  const Affichage({
    super.key,
    required this.themeController,
  });

  @override
  State<Affichage> createState() => _AffichageState();
}

class _AffichageState extends State<Affichage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _selectedIndex == 2
          ? null
          : AppBarPrincipal(
        title: 'Gestion des rendez-vous',
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const Connexion(),
                ),
              );
            },
          ),
        ],
      ),

      body: _selectedIndex == 0
          ? const Accueil()
          : _selectedIndex == 2
          ? Parametres(
        themeController: widget.themeController,
      )
          : const Center(
        child: Text(
          'Liste des réservations',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,

        onDestinationSelected: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },

        destinations: const [
          NavigationDestination(
            icon: Icon(MyFlutterApp.home_outline),
            selectedIcon: Icon(MyFlutterApp.home_outline),
            label: 'Accueil',
          ),

          NavigationDestination(
            icon: Icon(MyFlutterApp.calendar_alt),
            selectedIcon: Icon(MyFlutterApp.calendar_alt),
            label: 'Liste des reservations',
          ),

          NavigationDestination(
            icon: Icon(MyFlutterApp.cog),
            selectedIcon: Icon(MyFlutterApp.cog),
            label: 'Paramètres',
          ),
        ],
      ),
    );
  }
}