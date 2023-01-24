import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:um_ehailing/widgets/search_bar_widget.dart';
import 'package:um_ehailing/constants.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            height: size.height * .27,
            decoration: const BoxDecoration(
              // color: Color.fromRGBO(217, 221, 220, 1),
              color: kBackgroundColor,
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: [
                      Text(
                        "Good Day \nAkmal!",
                        style: Theme.of(context)
                            .textTheme
                            .displaySmall!
                            .copyWith(fontWeight: FontWeight.w900),
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Container(
                          alignment: Alignment.bottomRight,
                          height: 150,
                          width: 150,
                          child:
                              Image.asset("assets/icons/location_search.png"),
                        ),
                      ),
                    ],
                  ),
                  const SearchBar(),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
