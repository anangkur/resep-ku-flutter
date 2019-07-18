
class Meals {

  String strMeal;
  String strMealThumb;
  String idMeal;

	Meals.fromJsonMap(Map<String, dynamic> map): 
		strMeal = map["strMeal"],
		strMealThumb = map["strMealThumb"],
		idMeal = map["idMeal"];

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['strMeal'] = strMeal;
		data['strMealThumb'] = strMealThumb;
		data['idMeal'] = idMeal;
		return data;
	}
}
