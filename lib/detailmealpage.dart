import 'package:flutter/material.dart';
import 'model/meals.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'model/detailmeal.dart';
import 'model/resultdetail.dart';
import 'package:url_launcher/url_launcher.dart';

class Detailmeal extends StatefulWidget{

  final Meals data;
  const Detailmeal({Key key, this.data}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return DetailMealState(data);
  }
}

class DetailMealState extends State<Detailmeal>{

  final Meals data;
  DetailMeal detail;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  DetailMealState(this.data);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(title: Text(data.strMeal),),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Stack(
              alignment: Alignment(0.8, 1.15),
              children: <Widget>[
                Hero(
                  tag: data.idMeal,
                  child: Image.network(data.strMealThumb, fit: BoxFit.fitWidth),
                ),
                FloatingActionButton(
                  backgroundColor: Colors.white,
                  onPressed: (){
                    _launchURL(detail.strYoutube);
                  },
                  child: Icon(Icons.videocam, color: Colors.black,),
                ),
              ],
            ),
            FutureBuilder(
              future: _fetchDetailData(),
              builder: (context, snapshot){
                if(snapshot.hasData){
                  detail = snapshot.data.meals[0];
                  return _detailMeal(snapshot.data);
                }else if(snapshot.hasError){
                  return Container(child: Text(snapshot.error.toString(),), margin: EdgeInsets.all(20),);
                }else{
                  return Padding(
                    padding: const EdgeInsets.all(10),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Future _fetchDetailData() async {
    final response = await http.get('https://www.themealdb.com/api/json/v1/1/lookup.php?i=${data.idMeal}');
    if(response.statusCode == 200){
      return ResultDetail<DetailMeal>.fromJsonMap(json.decode(response.body));
    }else{
      return Exception('Failed to load data');
    }
  }

  Widget _detailMeal(ResultDetail<DetailMeal> data){
    return Container(
      margin: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(data.meals[0].strMeal, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Text(data.meals[0].strInstructions),
          )
        ],
      ),
    );
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}