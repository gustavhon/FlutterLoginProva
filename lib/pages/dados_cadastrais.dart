import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'user_model.dart';
import 'api_service.dart';

class DadosCadastraisPage extends StatefulWidget {
  const DadosCadastraisPage({Key? key}) : super(key: key);

  @override
  State<DadosCadastraisPage> createState() => _DadosCadastraisPageState();
}

class _DadosCadastraisPageState extends State<DadosCadastraisPage> {
  var nomeController = TextEditingController();
  var sobrenomeController = TextEditingController();
  var dataNascimentoController = TextEditingController();
  var emailController = TextEditingController();
  var senhaController = TextEditingController();
  var telefoneController = TextEditingController();
  var cidadeController = TextEditingController();
  var estadoController = TextEditingController();
  var cepController = TextEditingController();
  DateTime? dataNascimento;
  bool isObscureText = true;
  bool _loading = false;

  final estados = ['SP', 'RJ', 'MG', 'ES'];

  Future<void> _consultarCep() async {
    final cep = cepController.text.replaceAll(RegExp(r'[^0-9]'), '');
    if (cep.length == 8) {
      setState(() {
        _loading = true;
      });
      try {
        final response =
            await http.get(Uri.parse('https://viacep.com.br/ws/$cep/json/'));
        final json = jsonDecode(response.body);
        final viacepModel = ViaCEPModel.fromJson(json);
        setState(() {
          cidadeController.text = viacepModel.localidade ?? '';
          estadoController.text = viacepModel.uf ?? '';
          _loading = false;
        });
      } catch (e) {
        print('Error: $e');
        setState(() {
          _loading = false;
        });
      }
    } else {
      setState(() {
        cidadeController.text = '';
        estadoController.text = '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: const Text("Cadastrar Usuário")),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      controller: nomeController,
                      hintText: "Nome",
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildTextField(
                      controller: sobrenomeController,
                      hintText: "Sobrenome",
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              _buildDatePickerField(
                context,
                controller: dataNascimentoController,
                hintText: "Data de Nascimento",
              ),
              const SizedBox(height: 15),
              _buildTextField(
                controller: emailController,
                hintText: "Email",
              ),
              const SizedBox(height: 15),
              _buildTextField(
                controller: senhaController,
                hintText: "Senha",
                obscureText: isObscureText,
                suffixIcon: IconButton(
                  icon: Icon(
                    isObscureText ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() {
                      isObscureText = !isObscureText;
                    });
                  },
                ),
              ),
              const SizedBox(height: 15),
              _buildTextField(
                controller: telefoneController,
                hintText: "Telefone",
              ),
              const SizedBox(height: 15),
              _buildTextField(
                controller: cepController,
                hintText: "CEP",
                onChanged: (value) {
                  if (value.length == 8) {
                    _consultarCep();
                  }
                },
              ),
              const SizedBox(height: 15),
              _buildTextField(
                controller: estadoController,
                hintText: "Estado",
              ),
              const SizedBox(height: 15),
              _buildTextField(
                controller: cidadeController,
                hintText: "Cidade",
              ),
              const SizedBox(height: 30),
              if (_loading) CircularProgressIndicator(),
              _buildCadastrarButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    bool obscureText = false,
    Widget? suffixIcon,
    void Function(String)? onChanged,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      style: const TextStyle(color: Colors.black),
      decoration: InputDecoration(
        contentPadding:
            const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.black54),
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      onChanged: onChanged,
    );
  }

  Widget _buildDatePickerField(BuildContext context,
      {required TextEditingController controller, required String hintText}) {
    return TextField(
      controller: controller,
      readOnly: true,
      decoration: InputDecoration(
        contentPadding:
            const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.black54),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      onTap: () async {
        var data = await showDatePicker(
          context: context,
          initialDate: DateTime(2000, 1, 1),
          firstDate: DateTime(1900, 1, 1),
          lastDate: DateTime.now(),
        );
        if (data != null) {
          controller.text = "${data.day}/${data.month}/${data.year}";
          dataNascimento = data;
        }
      },
    );
  }

  Widget _buildCadastrarButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () async {
          if (_validateFields()) {
            User newUser = User(
              nome: nomeController.text,
              sobrenome: sobrenomeController.text,
              dataNascimento: dataNascimentoController.text,
              email: emailController.text,
              senha: senhaController.text,
              telefone: telefoneController.text,
              cidade: cidadeController.text,
              estado: estadoController.text,
              cep: cepController.text,
            );

            try {
              await ApiService.createUser(newUser);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text("Cadastro realizado com sucesso!")),
              );
              Navigator.pop(context);
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Erro ao cadastrar usuário: $e")),
              );
            }
          }
        },
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          backgroundColor: Colors.blueAccent,
        ),
        child: const Text(
          "Cadastrar",
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }

  bool _validateFields() {
    if (nomeController.text.isEmpty ||
        sobrenomeController.text.isEmpty ||
        dataNascimentoController.text.isEmpty ||
        emailController.text.isEmpty ||
        senhaController.text.isEmpty ||
        telefoneController.text.isEmpty ||
        cepController.text.isEmpty ||
        estadoController.text.isEmpty ||
        cidadeController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Preencha todos os campos")),
      );
      return false;
    }
    return true;
  }
}

class ViaCEPModel {
  final String logradouro;
  final String localidade;
  final String uf;

  ViaCEPModel(
      {required this.logradouro, required this.localidade, required this.uf});

  factory ViaCEPModel.fromJson(Map<String, dynamic> json) {
    return ViaCEPModel(
      logradouro: json['logradouro'],
      localidade: json['localidade'],
      uf: json['uf'],
    );
  }
}
