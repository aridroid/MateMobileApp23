import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:mate_app/asset/Colors/MateColors.dart';

class ImageSliderWithIndicator extends StatefulWidget {
  final List<Widget> list;
  const ImageSliderWithIndicator({Key? key, required this.list}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ImageSliderWithIndicatorState();
  }
}

class _ImageSliderWithIndicatorState extends State<ImageSliderWithIndicator> {
  int _current = 0;
  final CarouselController _controller = CarouselController();

  @override
  Widget build(BuildContext context) {
    return Column(
        children: [
      CarouselSlider(
        items: widget.list,
        carouselController: _controller,
        options: CarouselOptions(
            viewportFraction: 1.0,
            height: MediaQuery.of(context).size.height*0.28,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 5),
            onPageChanged: (index, reason) {
              setState(() {
                _current = index;
              });
            }),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: widget.list.asMap().entries.map((entry) {
          return GestureDetector(
            onTap: () => _controller.animateToPage(entry.key),
            child: Container(
              width: 8.0,
              height: 8.0,
              margin:
              const EdgeInsets.symmetric(vertical: 10.0, horizontal: 3.0),
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _current == entry.key ? MateColors.activeIcons: Colors.grey,
              ),
            ),
          );
        }).toList(),
      ),
    ],
    );
  }
}
