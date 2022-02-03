import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final myController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          //Ekrana sığdırılmasını sağlıyoruz
          fit: BoxFit.cover,
          image: AssetImage("assets/search.jpg"),
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          //Appbarın görünürlüğünü kapatıyoruz
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        backgroundColor: Colors.transparent,
        body: Center(
          child: Column(
            children: [
              const SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 60),
                child: TextField(
                  controller: myController,
                  decoration: const InputDecoration(
                    hintText: "Şehir Giriniz",
                    border: OutlineInputBorder(borderSide: BorderSide.none),
                  ),
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 26),
                ),
              ),
              FlatButton(
                onPressed: () async {
                  var response = await http.get(
                    Uri.https(
                      "www.metaweather.com",
                      "/api/location/search/",
                      {"query": "${myController.text}"},
                    ),
                  );
                  jsonDecode(response.body).isEmpty
                      ? Fluttertoast.showToast(msg: "Hatalı Şehir Seçimi!")
                      : Navigator.pop(context, myController.text);
                },
                child: Text("Şehri Seç"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
