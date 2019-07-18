import 'package:eudeka_publiccourse_finaltask/model/meals.dart';

class Result<T> {

  List<T> meals;

	Result.fromJsonMap(Map<String, dynamic> map): meals = List<T>.from(map["meals"].map((it) => Meals.fromJsonMap(it)));
}
