import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:tour360/screens/view_screen.dart';
import 'package:tour360/utils/api_config.dart';
import 'package:tour360/utils/palatte.dart';

class SearchListScreen extends StatefulWidget {
  final String search;
  const SearchListScreen({super.key, required this.search});

  @override
  State<SearchListScreen> createState() => _SearchListScreenState();
}

class _SearchListScreenState extends State<SearchListScreen> {
  bool isLoading = false;
  bool isError = false;
  Map<String, dynamic> data = {};
  final dio = Dio();
  @override
  void initState() {
    fetchData();
    super.initState();
  }

  fetchData() async {
    if (mounted) {
      setState(() {
        isLoading = true;
      });
    }
    try {
      var res = await dio.get(ApiConfig.buildSearchUrl(widget.search));
      if (res.statusCode == 200) {
        data = res.data;
      } else {
        isError = true;
      }
    } catch (e) {
      isError = true;
    }
    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Palatte.green,
        title: Text(
          widget.search,
          style: GoogleFonts.ubuntu(fontWeight: FontWeight.w500),
        ),
        foregroundColor: Palatte.white,
      ),
      backgroundColor: Palatte.backgroundColor,
      body: isLoading ? getLoader() : (isError ? getError() : getBody()),
    );
  }

  getBody() {
    List items = data['items'] ?? [];
    if (items.isEmpty) {
      return getError();
    }
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        return getImage(items[index]['link']);
      },
    );
  }

  getLoader() {
    return Lottie.asset("assets/loading2.json",
        width: MediaQuery.of(context).size.width);
  }

  getError() {
    return Lottie.asset("assets/error.json",
        width: MediaQuery.of(context).size.width * 0.9);
  }

  getImage(String? image) {
    if (image == null || image.isEmpty) Container();
    return InkWell(
      onTap: () {
        Get.to(ViewScreen(
          url: image ?? '',
          search: widget.search,
        ));
      },
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: const [
              BoxShadow(
                  color: Colors.black12,
                  blurRadius: 2.5,
                  spreadRadius: 2.5,
                  offset: Offset(1.5, 1.5))
            ]),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: CachedNetworkImage(
            imageUrl: image ?? "",
            width: MediaQuery.of(context).size.width,
            height: 135,
            fit: BoxFit.fitWidth,
            imageBuilder: (context, imageProvider) => Image(
              image: imageProvider,
              fit: BoxFit.fitWidth,
            ),
            errorWidget: (context, url, error) {
              return getError();
            },
            placeholder: (context, url) {
              return LinearProgressIndicator(
                color: Palatte.green,
              );
            },
          ),
        ),
      ),
    );
  }
}
