import 'package:eudeka_publiccourse_finaltask/model/detailmeal.dart';

class ResultDetail<T> {

  List<T> meals;

  ResultDetail.fromJsonMap(Map<String, dynamic> map): meals = List<T>.from(map["meals"].map((it) => DetailMeal.fromJsonMap(it)));
}
