import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:tour360/components/custom_search_delegate.dart';
import 'package:tour360/components/most_searched.dart';
import 'package:tour360/components/top_places.dart';
import 'package:tour360/utils/palatte.dart';
import 'package:tour360/utils/strings.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool searchClick = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        backgroundColor: Palatte.green,
      ),
      backgroundColor: Palatte.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Stack(
            children: [
              Lottie.asset('assets/header.json',
                  reverse: true, fit: BoxFit.fitWidth),
              BackdropFilter(
                filter: ImageFilter.blur(
                    sigmaX: 5, sigmaY: 5, tileMode: TileMode.mirror),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                Strings.welcome,
                                style: GoogleFonts.concertOne(
                                    shadows: <Shadow>[
                                      const Shadow(
                                          offset: Offset(1, 1),
                                          blurRadius: 2.0,
                                          color: Colors.black12),
                                    ],
                                    color: Colors.green.shade600,
                                    fontSize: 32,
                                    fontWeight: FontWeight.w600),
                              ),
                              InkWell(
                                onTap: () {
                                  showSearch(
                                    context: context,
                                    delegate: CustomSearchDelegate(),
                                  );
                                },
                                child: Lottie.asset('assets/search.json',
                                    animate: true,
                                    frameRate: const FrameRate(24),
                                    width: 40,
                                    height: 40,
                                    repeat: true,
                                    reverse: true),
                              )
                            ],
                          ),
                          Text(
                            Strings.toTheWorldOfTour360,
                            style: GoogleFonts.playpenSans(shadows: <Shadow>[
                              const Shadow(
                                  offset: Offset(1, 1),
                                  blurRadius: 2.0,
                                  color: Colors.black12),
                            ], fontSize: 20, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 6),
                    const MostSearched(),
                    const SizedBox(
                      height: 10,
                    ),
                    const TopPlaces()
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
