import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tour360/screens/search_list_screen.dart';
import 'package:tour360/utils/palatte.dart';
import 'package:tour360/utils/store.dart';

class CustomSearchDelegate extends SearchDelegate {
  List<String> searchTerms = searchList;

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: Icon(
          Icons.clear,
          color: Palatte.green,
        ),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: Icon(
        Icons.arrow_back,
        color: Palatte.green,
      ),
    );
  }

  @override
  buildResults(BuildContext context) {
    List<String> matchQuery = [];
    for (var location in searchTerms) {
      if (location.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(location);
      }
    }
    if (query.isNotEmpty && !matchQuery.contains(query)) {
      matchQuery.insert(0, query);
    }
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
          child: ListTile(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            tileColor: Palatte.green.withValues(alpha: 0.2),
            title: Text(
              result,
              style: GoogleFonts.ubuntu(),
            ),
            onTap: () {
              Navigator.pop(context);
              Get.to(SearchListScreen(search: result));
            },
          ),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> matchQuery = [];
    for (var location in searchTerms) {
      if (location.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(location);
      }
    }
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
          child: ListTile(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            tileColor: Palatte.green.withValues(alpha: 0.2),
            title: Text(
              result,
              style: GoogleFonts.ubuntu(),
            ),
            onTap: () {
              Navigator.pop(context);
              Get.to(SearchListScreen(search: result));
            },
          ),
        );
      },
    );
  }
}
