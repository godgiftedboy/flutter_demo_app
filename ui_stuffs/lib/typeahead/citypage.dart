import 'package:flutter/material.dart';
import 'package:ui_stuffs/typeahead/typeahead.dart';

class CityPage extends StatelessWidget {
  final City city;
  const CityPage({super.key, required this.city});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("${city.name} , ${city.country}"),
      ),
    );
  }
}
