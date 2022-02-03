import 'package:flutter/material.dart';
import 'package:hava_durumu/search_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:geolocator/geolocator.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String sehir = "ankara";
  int? sicaklik;
  var locationData;
  var woeid;
  String abbr = "c";
  Position? position;

  //Telefonun o anki konumunu alma
  Future getDevicePosition() async {
    try {
      position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.low);
    } catch (e) {
      print("Hata: $e");
    }

    print("position $position");
  }

  //Şehir adına göre apiden veri çek
  Future getLocationData() async {
    //Apinin urlsini aldık ve locationData değişkenine attık
    var url = Uri.https(
        "www.metaweather.com", "/api/location/search/", {"query": "$sehir"});

    locationData = await http.get(url);

    //locationDatanın body kısmını jsonDecode ile ayrıştırdık ve 0. indeks olan body kısmından
    //"woeid"yi alıp woeid değişkenine attık, artık şehirlerin idsi woeid değişkeninde tutuluyor
    var locationDataParsed = jsonDecode(locationData.body);
    woeid = locationDataParsed[0]["woeid"];
  }

  //enlem ve boylama göre apiden veri çek
  Future getLocationDataLatLong() async {
    //Apinin urlsini enlem ve boylama göre aldık ve locationData değişkenine attık
    var url = Uri.https("www.metaweather.com", "/api/location/search/",
        {"lattlong": "${position!.latitude},${position!.longitude}"});

    locationData = await http.get(url);

    //locationDatanın body kısmını jsonDecode ile ayrıştırdık ve 0. indeks olan body kısmından
    //"woeid"yi alıp woeid değişkenine attık, artık şehirlerin idsi woeid değişkeninde tutuluyor
    //var locationDataParsed = jsonDecode(locationData.body);
    //utf8 decode ile Türkçe karaktere uygun hale getirdik
    var locationDataParsed = jsonDecode(utf8.decode(locationData.bodyBytes));
    woeid = locationDataParsed[0]["woeid"];
    sehir = locationDataParsed[0]["title"];
  }

  //idsini aldığımız şehrin sıcaklık değerini ve hava durumu kısaltmalarını alıyoruz
  Future getLocationTemperature() async {
    var url = Uri.parse("https://www.metaweather.com/api/location/$woeid/");

    var response = await http.get(url);

    var temperatureData = jsonDecode(response.body);

    setState(() {
      //sıcaklık değişkeninin içi dolduğunda yenilenmesi için setState içine alındı
      sicaklik = temperatureData["consolidated_weather"][0]["the_temp"].round();
      //abbr değişkeninin içi dolduğunda yenilenmesi için setState içine alındı
      abbr = temperatureData["consolidated_weather"][0]["weather_state_abbr"];
    });
  }

  //id çekme işlemi tamamlandıktan sonra sıcaklık çekme işlemi gerçekleştirilecek
  void getDataFromAPI() async {
    //Cizhazdan konum bilgisi çekiyoruz
    await getDevicePosition();
    //lat ve long ile apiden woeid bilgisini çekiyoruz
    await getLocationDataLatLong();
    //woeid bilgisi ile sıcaklık bilgisi çekiliyor
    getLocationTemperature();
  }

  //Şehir bilgisi ile veri çek
  void getDataFromAPIbyCity() async {
    //şehir bilgisine göre apiden woeid bilgisini çekiyoruz
    await getLocationData();
    //woeid bilgisi ile sıcaklık bilgisi çekiliyor
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
      decoration: BoxDecoration(
        image: DecorationImage(
          //Ekrana sığdırılmasını sağlıyoruz
          fit: BoxFit.cover,
          image: AssetImage("assets/$abbr.jpg"),
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
                    Container(
                      height: 80,
                      width: 80,
                      child: Image.network(
                          "https://www.metaweather.com/static/img/weather/png/$abbr.png"),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      "$sicaklik°C",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 60,
                        shadows: [
                          Shadow(
                            color: Colors.black87,
                            blurRadius: 10,
                            offset: Offset(5, 5),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "$sehir",
                          style: const TextStyle(
                            fontSize: 30,
                            shadows: [
                              Shadow(
                                color: Colors.black87,
                                blurRadius: 15,
                                offset: Offset(4, 4),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          //secilen şehir bilgisi pop ile geri döndürüldüğü için ilk yönlendirme
                          //kısmına bu bilgiyi aktardı
                          onPressed: () async {
                            sehir = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SearchPage(),
                              ),
                            );
                            //Diğer sayfadan bu sayfaya geri dönüldüğünde apiyi tekrar çalıştır ve setstate ile ekranı yenile
                            getDataFromAPIbyCity();
                            setState(() {
                              sehir = sehir;
                            });
                          },
                          icon: const Icon(Icons.search),
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
