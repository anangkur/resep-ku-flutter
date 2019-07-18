import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:http/http.dart' as http;
import 'model/result.dart';
import 'dart:convert';
import 'model/meals.dart';
import 'detailmealpage.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: Colors.white
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final double _radiusCard = 14;

  Future _fetchData() async {
    final response = await http.get('https://www.themealdb.com/api/json/v1/1/filter.php?a=Italian');
    if (response.statusCode == 200) {
      return Result<Meals>.fromJsonMap(json.decode(response.body));
    } else {
      return Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text('Italian Food'),
        actions: <Widget>[
          PopupMenuButton<int>(
            itemBuilder: (context) => [
              PopupMenuItem<int>(
                child: Text('Keluar'),
                value: 1,
              )
            ],
            onSelected: (value){
              _showDialog();
            },
          )
        ],
      ),
      body: FutureBuilder(
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return _gridView(snapshot.data);
          } else if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()),);
          } else {
            return LinearProgressIndicator();
          }
        },
        future: _fetchData(),
      ),
    );
  }

  _showDialog(){
    showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            title: Text('Perhatian'),
            content: Text('Apakah anda yakin ingin keluar?'),
            actions: <Widget>[
              FlatButton(
                  onPressed: (){
                    exit(0);
                  },
                  child: Text('Ya')
              ),
              FlatButton(
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  child: Text('Tidak')
              )
            ],
          );
        }
    );
  }

  Widget _foodItem(Meals data) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(_radiusCard),
              topLeft: Radius.circular(_radiusCard)),
        ),
        child: InkWell(
          onTap: (){
            _gotoDetailPage(data);
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(_radiusCard),
                ),
                child: Hero(
                  tag: data.idMeal,
                  child: Image.network(data.strMealThumb,)
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 20, bottom: 10, left: 10, right: 10),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      data.strMeal,
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800]),
                    ),
                    Container(
                        margin: EdgeInsets.only(top: 10, bottom: 10),
                        child: Text(
                          'Id. ${data.idMeal}',
                          style: TextStyle(fontSize: 14, color: Colors.grey[400]),
                        )),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _gridView(Result data) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      color: Colors.grey[100],
      child: StaggeredGridView.builder(
        gridDelegate: SliverStaggeredGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          staggeredTileBuilder: (int index) => StaggeredTile.fit(1),
        ),
        itemBuilder: (context, position) {
          return _foodItem(data.meals[position]);
        },
        itemCount: data.meals.length,
      ),
    );
  }

  _gotoDetailPage(Meals data){
    Navigator.push(
      context,
      MaterialPageRoute(builder: (BuildContext context){
        return Detailmeal(data: data,);
      })
    );
  }
}
