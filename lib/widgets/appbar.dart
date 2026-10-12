import 'package:flutter/material.dart';

class AppBarPrincipal extends StatefulWidget
    implements PreferredSizeWidget {
  final String title;
  final List<Widget> actions;

  const AppBarPrincipal({
    super.key,
    this.title = 'Gestion des rendez-vous',
    this.actions = const [],
  });

  @override
  State<AppBarPrincipal> createState() => _AppBarPrincipalState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _AppBarPrincipalState extends State<AppBarPrincipal> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(widget.title),
      centerTitle: true,
      actions: widget.actions,
    );
  }
}