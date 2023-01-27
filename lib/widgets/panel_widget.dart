import 'package:flutter/material.dart';
import 'package:um_ehailing/constants.dart';

class PanelWidget extends StatelessWidget {
  final ScrollController controller;
  const PanelWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return ListView(
      controller: controller,
      padding: EdgeInsets.zero,
      children: [
        const SizedBox(height: 15),
        buildDragHandle(context),
        const Center(
          child: SizedBox(height: 15),
        ),
        buildBookingSummarySection(),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget buildBookingSummarySection() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Card(
          elevation: 0,
          color: kBackgroundColor,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(children: [
              Align(
                alignment: Alignment.centerRight,
                child: Container(
                  alignment: Alignment.centerRight,
                  height: 70,
                  width: 70,
                  child: Image.asset("assets/icons/car.png"),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text("Drive2U@UM ride",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: kTextColor)),
                    Text("Distance: | 12mins",
                        style: TextStyle(
                            color: Color.fromARGB(255, 75, 72, 72),
                            fontSize: 14,
                            fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            ]),
          ),
        ),
        const SizedBox(height: 50),
        const Text("""
Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum."""),
      ]),
    );
  }

  Widget buildDragHandle(BuildContext context) {
    double width = MediaQuery.of(context).size.width * 0.2;
    return Center(
      child: Container(
        width: width,
        height: 5,
        decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: const BorderRadius.vertical(
                top: Radius.circular(5.0), bottom: Radius.circular(5.0))),
      ),
    );
  }
}
