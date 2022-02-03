import 'package:flutter/material.dart';

class DailyWeather extends StatelessWidget {
  late String image, temp, date;

  DailyWeather({required this.image, required this.temp, required this.date});

  @override
  Widget build(BuildContext context) {
    List weekdays = [
      "Pazartesi",
      "Salı",
      "Çarşamba",
      "Perşembe",
      "Cuma",
      "Cumartesi",
      "Pazar"
    ];
    String weekday;

    //alınan tarihi parse edip haftanın kaçıncı günü olduğunu int cinsinden buluyoruz indexler 0 dan
    //başladığı için bulduğumuz değerden 1 çıkartıyoruz ve dizinin elemanı şeklinde weekday' atıyoruz

    weekday = weekdays[DateTime.parse(date).weekday - 1];

    return Card(
      elevation: 2,
      color: Colors.transparent,
      child: Container(
        height: 140,
        width: 100,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "$weekday",
              style: const TextStyle(
                fontSize: 16,
                shadows: [
                  Shadow(
                    color: Colors.black87,
                    blurRadius: 9,
                    offset: Offset(3, 3),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Image.network(
              "https://www.metaweather.com/static/img/weather/png/$image.png",
              height: 60,
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              "$temp°C",
              style: const TextStyle(
                fontSize: 15,
                shadows: [
                  Shadow(
                    color: Colors.black87,
                    blurRadius: 8,
                    offset: Offset(3, 3),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
