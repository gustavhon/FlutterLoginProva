// user_list_page.dart

import 'package:flutter/material.dart';
import 'user_model.dart';
import 'api_service.dart';
import 'user_form_page.dart';

class UserListPage extends StatefulWidget {
  @override
  _UserListPageState createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  late Future<List<User>> futureUsers;

  @override
  void initState() {
    super.initState();
    futureUsers = ApiService.getUsers();
  }

  void _refreshUsers() {
    setState(() {
      futureUsers = ApiService.getUsers();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Usuários'),
      ),
      body: FutureBuilder<List<User>>(
        future: futureUsers,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro ao carregar usuários'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Nenhum usuário encontrado'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final user = snapshot.data![index];
                return ListTile(
                  title: Text('${user.nome} ${user.sobrenome}'),
                  subtitle: Text(user.email),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () async {
                          final updatedUser = await Navigator.push<User>(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UserFormPage(user: user),
                            ),
                          );

                          if (updatedUser != null) {
                            await ApiService.updateUser(
                                user.objectId!, updatedUser);
                            _refreshUsers();
                          }
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () async {
                          await ApiService.deleteUser(user.objectId!);
                          _refreshUsers();
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          final newUser = await Navigator.push<User>(
            context,
            MaterialPageRoute(
              builder: (context) => UserFormPage(),
            ),
          );

          if (newUser != null) {
            await ApiService.createUser(newUser);
            _refreshUsers();
          }
        },
      ),
    );
  }
}
