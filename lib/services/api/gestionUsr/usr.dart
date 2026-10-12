class Usr {
  final int idutilisateur;
  final int? idrole;
  final String? nom;
  final String? prenom;
  final String? email;

  Usr({
    required this.idutilisateur,
    this.idrole,
    this.nom,
    this.prenom,
    this.email,
  });

  factory Usr.fromJson(Map<String, dynamic> json) {
    return Usr(
      idutilisateur: json['idutilisateur'],
      idrole: json['idrole'],
      nom: json['nom'],
      prenom: json['prenom'],
      email: json['email'],
    );
  }
}