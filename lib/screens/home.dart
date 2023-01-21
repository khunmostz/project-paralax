import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late ScrollController _scrollController;

  @override
  void initState() {
    // TODO: implement initState
    _scrollController = ScrollController()..addListener(_onScroll);
    super.initState();
  }

  late double _scrollOffset = 0.0;

  //speed layout
  double _layer1Speed = 0.55; // main layer // top layer
  double _layer2Speed = 0.50;
  double _layer3Speed = 0.45;
  double _layer4Speed = 0.375;
  double _sunSpeed = 1.5;

  double _textSpeed = 0.5;

  bool showText = false;
  double? _layoutHeight;
  double? _screenHeight;

  double _valueEndHeight = 0.0;
  double newOffset = 0.0;

  void _onScroll() {
    setState(() {
      _scrollOffset = _scrollController.offset;
      // print('offset: ${_scrollOffset}');

      if (_screenHeight == null || _layoutHeight == null) return;

      // print(
      //     'layout position ${_scrollOffset * _layer1Speed} ** middle screen ${_screenHeight! * 0.5}');

      if (_scrollOffset * _layer1Speed > _screenHeight! * 0.5) {
        showText = true;
      } else {
        showText = false;
      }
      if ((_scrollOffset * 0.55) + 200 >= (_screenHeight!)) {
        if (_valueEndHeight == 0) {
          _valueEndHeight = (_scrollOffset);
          // print('_valueEndHeight : ${_valueEndHeight}');
        }
        newOffset = (_scrollOffset - _valueEndHeight);
        // print('newoffset : ${newOffset}');
      } else {
        _valueEndHeight = 0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = Get.size;
    var layoutHeight = size.height * 3;

    _layoutHeight = layoutHeight;
    _screenHeight = size.height;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(255, 66, 240, 210),
              Color.fromARGB(255, 253, 244, 193),
            ],
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              bottom: (size.height * 0.6) * 0.3 +
                  (lerpDouble(
                          0, _sunSpeed * _scrollOffset, _scrollOffset / 900 - 1)
                      as double),
              // bottom: size.height * (0.5 + _sunSpeed * _scrollOffset),
              right: size.width * 0.3,
              left: 0,
              child: SvgPicture.asset('assets/sun.svg'),
            ),
            Positioned(
              bottom: _layer4Speed * _scrollOffset,
              right: (_layer4Speed * _scrollOffset) * -1,
              left: (_layer4Speed * _scrollOffset) * -1,
              child: SvgPicture.asset(
                'assets/mountains-layer-4.svg',
                alignment: Alignment.bottomCenter,
              ),
            ),
            Positioned(
              bottom: _layer3Speed * _scrollOffset,
              right: (_layer3Speed * _scrollOffset) * -1,
              left: (_layer3Speed * _scrollOffset) * -1,
              child: SvgPicture.asset(
                'assets/mountains-layer-2.svg',
                alignment: Alignment.bottomCenter,
              ),
            ),
            Positioned(
              bottom: -40 + _layer2Speed * _scrollOffset,
              right: (_layer2Speed * _scrollOffset) * -1,
              left: (_layer2Speed * _scrollOffset) * -1,
              child: SvgPicture.asset(
                'assets/trees-layer-2.svg',
                alignment: Alignment.bottomCenter,
              ),
            ),
            Positioned(
              bottom: -30 + _layer1Speed * _scrollOffset,
              right: (_layer1Speed * _scrollOffset) * -1,
              left: (_layer1Speed * _scrollOffset) * -1,
              height: size.height, // ตอนรูปขยายเข้า
              child: SvgPicture.asset(
                'assets/layer-1.svg',
                fit: BoxFit.fitWidth,
                alignment: Alignment.bottomCenter,
              ),
            ),
            Positioned(
              top: size.height + (_layer1Speed * _scrollOffset * -1),
              // top: 100 + (_layer1Speed * _scrollOffset * -1),  เอาไว้ดูย้อนหลัง
              bottom: 0,
              right: 0,
              left: 0,
              // height: size.height,
              child: Container(
                color: Colors.black,
                child: Center(
                    // child: AnimatedOpacity(
                    //   opacity: showText ? 1 : 0,
                    //   duration: 500.milliseconds,
                    //   child: Text(
                    //     'This is Paralax Effect',
                    //     style: TextStyle(
                    //       fontSize: 25,
                    //       color: Colors.white,
                    //     ),
                    //   ),
                    // ),
                    ),
              ),
            ),

            if (_valueEndHeight > 0) ...[
              ...contentsection(size),
            ],

           
            // scroll view
            Positioned.fill(
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                controller: _scrollController,
                child: SizedBox(
                  height: layoutHeight,
                ),
              ),
            ),

            Positioned(
              bottom: 20,
              child: Text(
                'mainOffset: ${_scrollOffset}',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> contentsection(Size size) {
    var ramenOffset = newOffset.clamp(0, 300);
    var ramenPercent = ramenOffset / 300;

    var textJapan = 0.0;
    var textNewOffset = 0.0;

    print('ramenP ${ramenOffset}');

    if (ramenOffset >= 300) {
      textJapan = _scrollOffset;
      // textJapan = (_scrollOffset -);
      textNewOffset = (textJapan - _scrollOffset);
      print('tnof: ${textJapan}');
    }

    return [
      AnimatedPositioned(
        duration: 0.milliseconds,
        top: lerpDouble(0, ramenOffset * 0.53, ramenPercent),
        left: (size.width / 2) - (100 / 2),
        // right: layoutHeight * 0.5,
        // width: 200,
        // height: 100,
        child: Transform.rotate(
          angle: lerpDouble(ramenOffset, 360, ramenPercent)! * pi / 180,
          child: Transform.scale(
            scale: ramenPercent + 0.4,
            child: Container(
              decoration:
                  BoxDecoration(border: Border.all(color: Colors.white)),
              child: Image.asset(
                'assets/images/ramen.png',
                width: 100,
                height: 100,
              ),
            ),
          ),
        ),
      ),
      // if (ramenPercent == 1.0) ...[
        Positioned(
          top: lerpDouble(0, ramenOffset * 0.53, ramenPercent),
          left: size.width /4,
          child: Transform.scale(
            scale: ramenPercent,
            child: Text(
              'ラーメン'.split("").join("\n"),
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
          ),
        ),
      // ]
    ];
  }
}
