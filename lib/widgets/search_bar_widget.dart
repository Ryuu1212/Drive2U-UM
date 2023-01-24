import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:um_ehailing/screens/search_screen.dart';
// import 'package:um_ehailing/screens/search_screen_test.dart';

class SearchBar extends StatelessWidget {
  const SearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 15),
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [
          BoxShadow(
            color: Colors.grey,
            offset: Offset(1.0, 2.0),
            blurRadius: 3.0,
          ),
        ],
      ),
      child: TextField(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const SearchScreen(),
              fullscreenDialog: true,
            ),
          );
        },
        readOnly: true,
        autofocus: false,
        showCursor: false,
        decoration: InputDecoration(
          hintText: "Where to?",
          hintStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 25,
          ),
          icon: Image.asset("assets/icons/placeholder.png",
              width: 20, height: 20),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
