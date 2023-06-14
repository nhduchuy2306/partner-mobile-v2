import 'package:flutter/material.dart';

class MySearchDelegate extends SearchDelegate {
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: const Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        Navigator.pop(context);
      },
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return const Center(
      child: Text("Results"),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return ListView.separated(
      itemBuilder: (context, index) {
        return ListTile(
          title: Text("Suggestion $index"),
        );
      },
      separatorBuilder: (context, index) {
        return const Divider();
      },
      itemCount: 10,
    );
  }
}
