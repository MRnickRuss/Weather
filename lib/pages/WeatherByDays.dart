import 'package:flutter/material.dart';
import 'package:weather_moscow/requests.dart';

class WeatherByDays extends StatefulWidget {
  @override
  State<WeatherByDays> createState() => _WeatherByDaysState();
}

class _WeatherByDaysState extends State<WeatherByDays> {
  List<WeatherData> weatherData = List.empty();

  @override
  void initState() {
    super.initState();
    String place = "";
    Future.delayed(Duration.zero, () {
      place = ModalRoute.of(context)?.settings.arguments as String;
    }).then((value) => { 
          fetchWeatherDays(place).then((result) => setState(() {
                weatherData = result;
              }))
        });
  }

    Widget buildWeatherInfo(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.black,
            fontSize: 22,
            fontWeight: FontWeight.w400,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: Colors.black,
            fontSize: 26,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 0, 127, 177),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 30),
          child: Center(
            child: Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white38,
                borderRadius: BorderRadius.circular(12.0),
              ),
              width: 380,
              height: 700,
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: weatherData.length,
                itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return Dialog(
                              child: Container(
                                color: Colors.grey[200],
                                padding: EdgeInsets.all(22),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      weatherData[index].time,
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 30,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    SizedBox(height: 20),
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(16.0),
                                      child: Image(
                                        image: AssetImage(
                                            'assets/${weatherData[index].imageName}.jpg'),
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                    SizedBox(height: 30),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        buildWeatherInfo('Температура',
                                            '${weatherData[index].temperature}°'),
                                        SizedBox(
                                            height:
                                                10), 
                                        buildWeatherInfo('Ощущается как',
                                            '${weatherData[index].feelsLike}°'),
                                        SizedBox(
                                            height:
                                                10), 
                                        buildWeatherInfo('Скорость ветра',
                                            '${weatherData[index].windSpeed}м/c'),
                                        SizedBox(
                                            height:
                                                10), 
                                        buildWeatherInfo('Влажность',
                                            '${weatherData[index].humidity}%'),
                                        SizedBox(
                                            height:
                                                10), 
                                        buildWeatherInfo('Давление',
                                            '${weatherData[index].pressure}мм.'),
                                        SizedBox(
                                            height:
                                                5), 
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                      child: Container(
                        height: 75,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: 110,
                              child: Text(
                                weatherData[index].time,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Container(
                              width: 170,
                              child: Text(
                                weatherData[index].description,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                ),
                                overflow: TextOverflow.visible,
                              ),
                            ),
                            Container(
                              width: 50,
                              child: Text(
                                "${weatherData[index].temperature}°",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ));
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
