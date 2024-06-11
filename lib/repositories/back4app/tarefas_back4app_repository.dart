
import 'package:trilhaapp/repositories/back4app/tarefas_back4app_model.dart';

class TarefasBack4AppRepository {
  Future<TarefasBack4AppModel> obterTarefas() async {
    var dio = Dio();
    dio.options.headers["X-Parse-Application-Id"] = 
    "kmiiMzHmOqLIh9nYfPcLOWStmNbyx4t4mNG6KxZk";
    dio.options.headers["X-Parse-REST-API-Key"] = 
    "2iKcDr8QRuiHFK9NTL0NK8XJHRPOt7rAq7csgWHb";
    dio.options.headers["Content-Type"] = 
    "application/json";
    var result = await dio.get("https://parseapi.back4app.com/classes/Tarefas");
    return TarefasBack4AppModel.fromJson(result.data);
  }
  
  Dio() {}
}