import 'package:flutter/material.dart';
import 'package:weather_moscow/requests.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/services.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => NameState();
}

class NameState extends State<HomePage> {
  TextEditingController place = new TextEditingController();
  String temperature = "";
  String weatherType = "";
  String wind = "";
  String dayTime = takeNameOfDayTime();

  @override
  void initState() {
    super.initState();
    _getLocation().then((placeInput) {
      fetchWeather(placeInput).then((result) => setState(() {
            temperature = result.$1;
            weatherType = result.$2;
            wind = result.$3;
            place.text = result.$4;
          }));
      checkInternetConnection();
    });
  }

  Future<void> checkInternetConnection() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      _showInternetDialog();
    }
  }

  void _showInternetDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Отсутствует подключение к интернету'),
          content: Text(
              'Пожалуйста, подключитесь к интернету, чтобы продолжить использование приложения.'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<String> _getLocation() async {
    LocationPermission _ = await Geolocator.requestPermission();
    Position position = await Geolocator.getCurrentPosition();
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    return placemarks[0].locality.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 0, 183, 255),
      body: SafeArea(
        child: Column(mainAxisSize: MainAxisSize.max, children: [
          const SizedBox(height: 60),
          Center(
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: Image(
                  image: AssetImage('assets/$dayTime.gif'),
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          const SizedBox(height: 40),
          Center(
            child: Container(
                width: 300,
                height: 220,
                child: Column(
                  children: [
                    Row(
                      children: [
                        SizedBox(width: 20),
                        Expanded(
                          child: TextField(
                            controller: place,
                            onSubmitted: (value) {
                              String modifiedString = value
                                  .replaceAll(RegExp(r'[^\w\sа-яёА-ЯЁ]'), '')
                                  .replaceAll(RegExp(r'\s+'), '');
                              fetchWeather(modifiedString)
                                  .then((result) => setState(() {
                                        temperature = result.$1;
                                        weatherType = result.$2;
                                        wind = result.$3;
                                        place.text = result.$4;
                                      }));
                            },
                            onTap: () {
                              Clipboard.setData(
                                ClipboardData(text: place.text),
                              );
                              place.selection = TextSelection(
                                baseOffset: 0,
                                extentOffset: place.text.length,
                              );
                            },
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Ваш город:',
                              hintStyle: TextStyle(color: Colors.white),
                              counterText: "",
                            ),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 40,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLength: 14,
                          ),
                        ),
                        SizedBox(width: 20),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "$temperature°",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 70,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(width: 20),
                        Flexible(
                          child: Text(
                            weatherType,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                              fontWeight: FontWeight.w500,
                            ),
                            overflow: TextOverflow.visible,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 15),
                    Center(
                      child: Text(
                        "Ветер: $wind м.c",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 36,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    )
                  ],
                )),
          ),
          const SizedBox(height: 55),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(
                context,
                '/weatherByDays',
                arguments: place.text,
              );
            },
            style: ButtonStyle(
              alignment: Alignment.center,
              fixedSize: MaterialStateProperty.all(Size(320, 90)),
              backgroundColor: MaterialStateProperty.all(Colors.orange),
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
              ),
            ),
            child: Text(
              "Прогноз на несколько дней",
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
