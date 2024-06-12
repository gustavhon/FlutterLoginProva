import 'dart:convert';
import 'package:http/http.dart' as http;
import 'user_model.dart';

class ApiService {
  static const String _baseUrl =
      'https://parseapi.back4app.com/classes/Tarefas';
  static const String _appId = 'kmiiMzHmOqLIh9nYfPcLOWStmNbyx4t4mNG6KxZk';
  static const String _restApiKey = '2iKcDr8QRuiHFK9NTL0NK8XJHRPOt7rAq7csgWHb';
  static Future<List<User>> getUsers() async {
    final response = await http.get(
      Uri.parse(_baseUrl),
      headers: {
        'X-Parse-Application-Id': _appId,
        'X-Parse-REST-API-Key': _restApiKey,
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body)['results'] as List;
      return data.map((json) => User.fromJson(json)).toList();
    } else {
      throw Exception('Erro ao carregar usuários');
    }
  }

  static Future<void> createUser(User user) async {
    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: {
        'X-Parse-Application-Id': _appId,
        'X-Parse-REST-API-Key': _restApiKey,
        'Content-Type': 'application/json',
      },
      body: json.encode(user.toJson()),
    );

    if (response.statusCode != 201) {
      throw Exception('Erro ao criar usuário');
    }
  }

  static Future<void> updateUser(String objectId, User user) async {
    final response = await http.put(
      Uri.parse('$_baseUrl/$objectId'),
      headers: {
        'X-Parse-Application-Id': _appId,
        'X-Parse-REST-API-Key': _restApiKey,
        'Content-Type': 'application/json',
      },
      body: json.encode(user.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Erro ao atualizar usuário');
    }
  }

  static Future<void> deleteUser(String objectId) async {
    final response = await http.delete(
      Uri.parse('$_baseUrl/$objectId'),
      headers: {
        'X-Parse-Application-Id': _appId,
        'X-Parse-REST-API-Key': _restApiKey,
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Erro ao deletar usuário');
    }
  }
}
