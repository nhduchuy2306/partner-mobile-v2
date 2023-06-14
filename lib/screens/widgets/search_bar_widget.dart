import 'package:flutter/material.dart';
import 'package:partner_mobile/screens/widgets/search_bar_delegate.dart';

class SearchBarWidget extends StatefulWidget {
  const SearchBarWidget({super.key});

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showSearch(
          context: context,
          delegate: MySearchDelegate(),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        width: double.maxFinite,
        decoration: BoxDecoration(
          color: const Color(0xFFF2F3F2),
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(Icons.search),
            SizedBox(
              width: 8,
            ),
            Text(
              "Search",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF7C7C7C),
              ),
            )
          ],
        ),
      ),
    );
  }
}
