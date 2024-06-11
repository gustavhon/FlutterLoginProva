import 'package:flutter/material.dart';
import 'user_model.dart';

class UserFormPage extends StatefulWidget {
  final User? user;

  UserFormPage({this.user});

  @override
  _UserFormPageState createState() => _UserFormPageState();
}

class _UserFormPageState extends State<UserFormPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController nomeController;
  late TextEditingController sobrenomeController;
  late TextEditingController dataNascimentoController;
  late TextEditingController emailController;
  late TextEditingController senhaController;
  late TextEditingController telefoneController;
  late TextEditingController cidadeController;
  late TextEditingController estadoController;
  late TextEditingController cepController;

  @override
  void initState() {
    super.initState();

    final user = widget.user;

    nomeController = TextEditingController(text: user?.nome ?? '');
    sobrenomeController = TextEditingController(text: user?.sobrenome ?? '');
    dataNascimentoController =
        TextEditingController(text: user?.dataNascimento ?? '');
    emailController = TextEditingController(text: user?.email ?? '');
    senhaController = TextEditingController(text: user?.senha ?? '');
    telefoneController = TextEditingController(text: user?.telefone ?? '');
    cidadeController = TextEditingController(text: user?.cidade ?? '');
    estadoController = TextEditingController(text: user?.estado ?? '');
    cepController = TextEditingController(text: user?.cep ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.user == null ? 'Criar Usuário' : 'Editar Usuário'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
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
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final user = User(
                      objectId: widget.user?.objectId,
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
                    Navigator.pop(context, user);
                  }
                },
                child: Text(widget.user == null ? 'Criar' : 'Atualizar'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor, insira $hintText';
        }
        return null;
      },
    );
  }

  Widget _buildDatePickerField(BuildContext context,
      {required TextEditingController controller, required String hintText}) {
    return TextFormField(
      controller: controller,
      readOnly: true,
      decoration: InputDecoration(
        hintText: hintText,
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
        }
      },
    );
  }
}
