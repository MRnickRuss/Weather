import 'dart:convert';
import 'package:http/http.dart' as http;

Future<(String temp, String weather, String Wind, String place)> fetchWeather(String place) async {
  String apiKey = '6534518d0a8fcab85184208ace32b936';
  String cityName = place;
  String units = 'metric';
  String cnt = '1';
  String language = 'ru';

  final Uri uri = Uri.https('api.openweathermap.org', '/data/2.5/weather', {
    'q': cityName,
    'units': units,
    'appid': apiKey,
    'cnt': cnt,
    'lang': language,
  });

  final response = await http.get(uri);

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    final dynamic temperature = data['main']['temp'];
    String weather = data['weather'][0]['description'];
    dynamic wind = data['wind']['speed'];
    String placeLocal = data['name'];

    weather = "${weather[0].toUpperCase()}${weather.substring(1)}";
    return (temperature.toInt().toString(), weather, wind.toString(), placeLocal);
  } else {
    throw Exception('Failed to fetch weather data: ${response.reasonPhrase}');
  }
}

String takeNameOfDayTime() {
  DateTime now = DateTime.now().toUtc();

  if (now.hour >= 0 && now.hour < 6) {
    return 'night';
  } else if (now.hour >= 6 && now.hour < 12) {
    return 'morning';
  } else if (now.hour >= 12 && now.hour < 18) {
    return 'day';
  } else if (now.hour >= 18 && now.hour < 24) {
    return 'evening';
  } else {
    return 'day';
  }
}

String takeTimeName(DateTime time) {
  List<String> weekDays = ['ПН', 'ВТ', 'СР', 'ЧТ', 'ПТ', 'СБ', 'ВС'];

  String dayName = "";
  if (time.day == DateTime.now().day)
    dayName = "Сегодня";
  else if (time.day == DateTime.now().add(Duration(days: 1)).day)
    dayName = "Завтра";
  else
    dayName = weekDays[time.weekday - 1];

  return "$dayName ${time.hour}:00";
}

Future<List<WeatherData>> fetchWeatherDays(String place) async {
  String apiKey = '6534518d0a8fcab85184208ace32b936';
  String cityName = place;
  String units = 'metric';
  String language = 'ru';

  final Uri uri = Uri.https('api.openweathermap.org', 'data/2.5/forecast', {
    'q': cityName,
    'units': units,
    'appid': apiKey,
    'lang': language,
  });

  final response = await http.get(uri);

  if (response.statusCode == 200) {
    Map<String, dynamic> jsonData = jsonDecode(response.body);

    List<dynamic> forecastData = jsonData['list'];
    List<WeatherData> weatherDataList = [];

    for (var i = 0; i < 40; i++) {
      Map<String, dynamic> forecast = forecastData[i];

      String weather = forecast['weather'][0]['description'];
      String time = forecast['dt_txt'];

      time = takeTimeName(DateTime.parse(time));
      String temp = forecast['main']['temp'].toInt().toString();
      String windSpeed = forecast['wind']['speed'].toString();
      String feelsLike = forecast['main']['feels_like'].toInt().toString();
      String humidity = forecast['main']['humidity'].toString();
      String pressure = forecast['main']['pressure'].toString();

      String code = forecast['weather'][0]['id'].toString();
      String imageName = "";
      if (code.startsWith("5"))
        imageName = "rain";
      else if (code.startsWith("6"))
        imageName = "snow";
      else if (code == "800")
        imageName = "shine";
      else if (code.startsWith("8"))
        imageName = "clouds";

      WeatherData weatherData = WeatherData(time, weather, temp, windSpeed, feelsLike, humidity, pressure, imageName);
      weatherDataList.add(weatherData);
    }

    return weatherDataList;
  } else {
    throw Exception('Failed to fetch weather data');
  }
}

class WeatherData {
  final String time;
  final String description;
  final String temperature;
  final String windSpeed;
  final String feelsLike;
  final String humidity;
  final String pressure;
  final String imageName;
  
  WeatherData(this.time, this.description, this.temperature, this.windSpeed, this.feelsLike, this.humidity, this.pressure, this.imageName);
}