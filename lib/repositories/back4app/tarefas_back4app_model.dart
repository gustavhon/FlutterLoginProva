class TarefasBack4AppModel {
  List<Tarefa>? results = [];

  TarefasBack4AppModel({this.results});

  TarefasBack4AppModel.fromJson(Map<String, dynamic> json) {
    if (json['results'] != null) {
      results = <Tarefa>[];
      json['results'].forEach((v) {
        results!.add(new Tarefa.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.results != null) {
      data['results'] = this.results!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Tarefa {
  String? objectId = "";
  String? createdAt = "";
  String? updatedAt = "";
  bool? concluido = false;
  String? descricao = "";

  Tarefa(
      {this.objectId,
      this.createdAt,
      this.updatedAt,
      this.concluido,
      this.descricao});

  Tarefa.fromJson(Map<String, dynamic> json) {
    objectId = json['objectId'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    concluido = json['concluido'];
    descricao = json['descricao'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['objectId'] = this.objectId;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['concluido'] = this.concluido;
    data['descricao'] = this.descricao;
    return data;
  }
}