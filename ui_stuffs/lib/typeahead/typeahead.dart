import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
// import 'package:ui_stuffs/typeahead/citypage.dart';

class TypeaheadPage extends StatelessWidget {
  const TypeaheadPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<City> cityList = [
      const City("Delhi", "India"),
      const City("Ktm", "Nepal"),
      const City("Bkt", "Nepal"),
      const City("Patan", "Nepal"),
    ];
    final List<City> suggestions = [];
    List<City> getSuggestions(String query) {
      suggestions.clear();
      suggestions.addAll(cityList);
      suggestions.retainWhere(
          (s) => "(${s.name})".toLowerCase().contains(query.toLowerCase()));
      return suggestions;
    }

    TextEditingController searchController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text("TypeAheadDemo"),
      ),
      body: TypeAheadField<City>(
        suggestionsCallback: (search) => getSuggestions(search),
        builder: (context, controller, focusNode) {
          searchController = controller;
          return TextField(
              controller: controller,
              focusNode: focusNode,
              autofocus: true,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'City',
              ));
        },
        itemBuilder: (context, city) {
          return ListTile(
            title: Text(city.name),
            subtitle: Text(city.country),
          );
        },

        listBuilder: (context, children) => GridView.count(
          // controller: scrollContoller,
          crossAxisCount: 3,
          crossAxisSpacing: 1,
          mainAxisSpacing: 1,
          shrinkWrap: true,
          reverse: SuggestionsController.of<City>(context).effectiveDirection ==
              VerticalDirection.up,
          children: children,
        ),
        onSelected: (city) {
          // Navigator.of(context).push<void>(
          //   MaterialPageRoute(
          //     builder: (context) => CityPage(city: city),
          //   ),
          // );

          //If you just want to set the value instead of Navigating
          searchController.text = city.name;
        },
        // debounceDuration: const Duration(seconds: 5),
      ),
    );
  }
}

class City {
  final String name;
  final String country;
  const City(this.name, this.country);
}
