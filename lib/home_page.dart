import 'package:flutter/material.dart';
import 'package:hava_durumu/search_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String sehir = "Ankara";
  int? sicaklik;
  var locationData;
  var woeid;

  Future getLocationData() async {
    //Apinin urlsini aldık ve locationData değişkenine attık
    var url = Uri.https(
        "www.metaweather.com", "/api/location/search/", {"query": "izmir"});

    locationData = await http.get(url);

    //locationDatanın body kısmını jsonDecode ile ayrıştırdık ve 0. indeks olan body kısmından
    //"woeid"yi alıp woeid değişkenine attık, artık şehirlerin idsi woeid değişkeninde tutuluyor
    var locationDataParsed = jsonDecode(locationData.body);
    woeid = locationDataParsed[0]["woeid"];
  }

  //idsini aldığımız şehrin sıcaklık gibi değerlerini alıyoruz
  Future getLocationTemperature() async {
    var url = Uri.parse("https://www.metaweather.com/api/location/$woeid/");

    var response = await http.get(url);

    var temperatureData = jsonDecode(response.body);

    //sıcaklık değişkeninin içi dolduğunda yenilenmesi için setState içine alındı
    setState(() {
      sicaklik = temperatureData["consolidated_weather"][0]["the_temp"].round();
    });
  }

  //id çekme işlemi tamamlandıktan sonra sıcaklık çekme işlemi gerçekleştirilecek
  void getDataFromAPI() async {
    await getLocationData();
    getLocationTemperature();
  }

  @override
  void initState() {
    getDataFromAPI();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          //Ekrana sığdırılmasını sağlıyoruz
          fit: BoxFit.cover,
          image: AssetImage("assets/c.jpg"),
        ),
      ),
      //sicaklik değeri boş ise progress döndür doluysa scaffoldu göster
      child: sicaklik == null
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Scaffold(
              backgroundColor: Colors.transparent,
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "$sicaklik°C",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 60,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Ankara",
                          style: TextStyle(
                            fontSize: 30,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SearchPage(),
                              ),
                            );
                          },
                          icon: Icon(Icons.search),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
