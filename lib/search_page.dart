import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
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
            children: const [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 60),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Şehir Giriniz",
                    border: OutlineInputBorder(borderSide: BorderSide.none),
                  ),
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 26),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
