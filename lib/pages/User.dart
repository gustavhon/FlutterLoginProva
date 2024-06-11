// user_model.dart

class User {
  final String? objectId;
  final String nome;
  final String sobrenome;
  final String dataNascimento;
  final String email;
  final String senha;
  final String telefone;
  final String cidade;
  final String estado;
  final String cep;

  User({
    this.objectId,
    required this.nome,
    required this.sobrenome,
    required this.dataNascimento,
    required this.email,
    required this.senha,
    required this.telefone,
    required this.cidade,
    required this.estado,
    required this.cep,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      objectId: json['objectId'],
      nome: json['nome'],
      sobrenome: json['sobrenome'],
      dataNascimento: json['dataNascimento'],
      email: json['email'],
      senha: json['senha'],
      telefone: json['telefone'],
      cidade: json['cidade'],
      estado: json['estado'],
      cep: json['cep'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nome': nome,
      'sobrenome': sobrenome,
      'dataNascimento': dataNascimento,
      'email': email,
      'senha': senha,
      'telefone': telefone,
      'cidade': cidade,
      'estado': estado,
      'cep': cep,
    };
  }
}
