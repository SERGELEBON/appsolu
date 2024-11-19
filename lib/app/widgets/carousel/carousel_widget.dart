/*import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:carousel_slider/carousel_controller.dart' as carousel_controller;

class CarouselWidget extends StatelessWidget {
  final List<String> imgList = [
    'assets/images/carousel1.png',
    'assets/images/carousel2.png',
    'assets/images/carousel3.png',
  ];

  final carousel_controller.CarouselController buttonCarouselController = carousel_controller.CarouselController();

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(
        height: 200.0,
        autoPlay: true,
        enlargeCenterPage: true,
      ),
      items: imgList.map((item) => Container(
        child: Center(
          child: Image.asset(item, fit: BoxFit.cover, width: 1000),
        ),
      )).toList(),
      carouselController: buttonCarouselController,
    );
  }
}
 */
