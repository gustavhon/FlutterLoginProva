import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ConsultaCep extends StatefulWidget {
  const ConsultaCep({Key? key}) : super(key: key);

  @override
  State<ConsultaCep> createState() => _ConsultaCepState();
}

class _ConsultaCepState extends State<ConsultaCep> {
  final _cepController = TextEditingController();
  String _endereco = '';
  String _cidade = '';
  String _estado = '';
  bool _loading = false;

  Future<void> _consultarCep() async {
    final cep = _cepController.text.replaceAll(RegExp(r'[^0-9]'), '');
    if (cep.length == 8) {
      setState(() {
        _loading = true;
      });
      try {
        final response = await http.get(Uri.parse('https://viacep.com.br/ws/$cep/json/'));
        final json = jsonDecode(response.body);
        final viacepModel = ViaCEPModel.fromJson(json);
        setState(() {
          _cidade = viacepModel.localidade?? '';
          _estado = viacepModel.uf?? '';
          _endereco = viacepModel.logradouro?? '';
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
        _cidade = '';
        _estado = '';
        _endereco = '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            children: [
              _Header(),
              _CepInput(
                controller: _cepController,
                onSubmitted: _consultarCep,
              ),
              SizedBox(height: 50),
              _AddressDisplay(
                endereco: _endereco,
                cidade: _cidade,
                estado: _estado,
              ),
              Visibility(
                visible: _loading,
                child: CircularProgressIndicator(),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: _consultarCep,
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text(
      'Consulta de CEP',
      style: TextStyle(fontSize: 22),
    );
  }
}

class _CepInput extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSubmitted;

  _CepInput({required this.controller, required this.onSubmitted});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLength: 8,
      onSubmitted: (_) => onSubmitted(),
    );
  }
}

class _AddressDisplay extends StatelessWidget {
  final String endereco;
  final String cidade;
  final String estado;

  _AddressDisplay({required this.endereco, required this.cidade, required this.estado});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          endereco,
          style: TextStyle(fontSize: 22),
        ),
        Text(
          '$cidade - $estado',
          style: TextStyle(fontSize: 22),
        ),
      ],
    );
  }
}

class ViaCEPModel {
  final String logradouro;
  final String localidade;
  final String uf;

  ViaCEPModel({required this.logradouro, required this.localidade, required this.uf});

  factory ViaCEPModel.fromJson(Map<String, dynamic> json) {
    return ViaCEPModel(
      logradouro: json['logradouro'],
      localidade: json['localidade'],
      uf: json['uf'],
    );
  }
}