import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/secrets.dart';
import 'hourly_forecast.dart';
import 'additional_info.dart';
import 'package:http/http.dart' as http;

class WeatherScreen extends StatefulWidget{
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  late Future<Map<String, dynamic>> weather;
  Future<Map<String, dynamic>> getCurrentWeather() async{
    try{
      String cityName = 'hyderabad';
      final res = await http.get(
        Uri.parse(
            'https://api.openweathermap.org/data/2.5/forecast?q=$cityName&APPID=$openWeatherApiKey'
        ),
      );
      
     final data =  jsonDecode(res.body);

      if(data['cod'] != '200'){
        throw 'An unexpected error occurred';
      }

        return data;
      
    }catch(e){
      throw e.toString();
    }
  }

  @override
  void initState(){
    super.initState();
    weather = getCurrentWeather();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text(
            "Weather App",
             style: TextStyle(
               fontWeight: FontWeight.bold,
             ),
        ),
        centerTitle: true,
        actions: [
          IconButton(onPressed: (){
            setState(() {
            });
          },
              icon: Icon(Icons.refresh)),
        ],
      ),

      body: FutureBuilder(
          future:getCurrentWeather(),
          builder: (context,snapshot) {
            if(snapshot.connectionState == ConnectionState.waiting){
              return Center(child:CircularProgressIndicator.adaptive());
            }
            else if(snapshot.hasError){
              return Text(snapshot.error.toString());
            }

            final data = snapshot.data!;

            final currentTemp = data["list"][0]['main']['temp'];
            final currentSky = data['list'][0]['weather'][0]['main'];
            final pressure = data['list'][0]['main']['pressure'];
            final humidity = data['list'][0]['main']['humidity'];
            final windSpeed = data['list'][0]['wind']['speed'];

            return Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //main card
            SizedBox(
              width: double.infinity,
              child: Card(
                elevation: 15,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),

                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaY: 5, sigmaX: 5),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: Column(
                        children: [
                          Text(
                              "$currentTemp K",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 30,
                              ),
                          ),

                          const SizedBox(height: 12),

                          Icon(
                            currentSky == 'Clouds' || currentSky == 'Rain'
                                ? Icons.cloud
                                : Icons.sunny,
                            size: 55,
                          ),

                          const SizedBox(height: 12),

                          Text(
                            currentSky,
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),
            Text(
              'Weather Forecast',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),

            SizedBox(
              height: 120,
              child: ListView.builder(
                  itemCount: 5,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context,index){
                    final hourlyForcast = data['list'][index+1];
                    final hourlyClimate = hourlyForcast['weather'][0]['main'];
                    final hourlyTime = DateTime.parse(hourlyForcast['dt_txt']);
                    return HourlyForcast(
                        time: DateFormat.j().format(hourlyTime),
                        value: hourlyForcast['main']['temp'].toString(),
                        icon: hourlyClimate == 'Clouds' || hourlyClimate == 'Rain'
                                ?Icons.cloud
                                :Icons.sunny,
                    );
                  },
              ),
            ),

            const SizedBox(height: 20),
            //additional information
            Text(
              'Additional Information',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                AdditionalInfo(
                  icon: Icons.water_drop_rounded,
                  label: "Humidity",
                  value: humidity.toString()
                ),
                AdditionalInfo(
                    icon: Icons.air_rounded,
                    label: "Wind Speed",
                    value: windSpeed.toString(),
                ),
                AdditionalInfo(
                    icon: Icons.beach_access_rounded,
                    label: "Pressure",
                    value: pressure.toString(),
                )
              ],
            )
          ],
        ),
      );
          },
      ),
    );
  }
}



