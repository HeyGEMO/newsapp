import 'dart:convert';
import 'package:newsapp/models/news_models.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:newsapp/screens/details_screen.dart';

// ignore: must_be_immutable
class Category extends StatefulWidget {
  final String query;
  const Category({super.key, required this.query});

  @override
  State<Category> createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  List<NewsData> newsModelList = <NewsData>[];
  bool isLoading = true;
  getNewsByQuery(String query) async {
    String url = "";
    if (query.toLowerCase() == "business" ||
        query.toLowerCase() == "entertainment" ||
        query.toLowerCase() == "technology" ||
        query.toLowerCase() == "sports" ||
        query.toLowerCase() == "health") {
      url =
          "https://newsapi.org/v2/top-headlines?country=us&category=${query.toLowerCase()}&apiKey=aaf6c84c087b4b9ba8c41e65aef6074f";
    } else {
      url =
          "https://newsapi.org/v2/everything?domains=wsj.com&apiKey=aaf6c84c087b4b9ba8c41e65aef6074f";
    }
    Response response = await get(Uri.parse(url));
    Map data = jsonDecode(response.body);
    setState(() {
      data["articles"].forEach((element) {
        NewsData newsQueryModel = NewsData();
        newsQueryModel = NewsData.fromMap(element);
        newsModelList.add(newsQueryModel);
        setState(() {
          isLoading = false;
        });
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getNewsByQuery(widget.query);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.blueGrey,
        title: const Text(
          "NewsApp",
          style: TextStyle(
              color: Color.fromARGB(255, 2, 247, 255),
              fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          Container(
            margin: const EdgeInsets.fromLTRB(15, 25, 0, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  widget.query,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 28),
                ),
              ],
            ),
          ),
          isLoading
              ? SizedBox(
                  height: MediaQuery.of(context).size.height - 350,
                  child: const Center(child: CircularProgressIndicator()))
              : ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: newsModelList.length,
                  itemBuilder: (context, index) {
                    try {
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DetailsScreen(
                                        data: newsModelList[index],
                                      )));
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                              elevation: 1.0,
                              child: Stack(
                                children: [
                                  ClipRRect(
                                      borderRadius: BorderRadius.circular(15),
                                      child: Image.network(
                                        newsModelList[index].urlToImage ?? "",
                                        fit: BoxFit.fitHeight,
                                        height: 230,
                                        width: double.infinity,
                                      )),
                                  Positioned(
                                      left: 0,
                                      right: 0,
                                      bottom: 0,
                                      child: Container(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              gradient: LinearGradient(
                                                  colors: [
                                                    Colors.black12
                                                        .withOpacity(0),
                                                    Colors.black
                                                  ],
                                                  begin: Alignment.topCenter,
                                                  end: Alignment.bottomCenter)),
                                          padding: const EdgeInsets.fromLTRB(
                                              15, 15, 10, 8),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                newsModelList[index].title ??
                                                    "",
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(
                                                newsModelList[index]
                                                            .content!
                                                            .length >
                                                        50
                                                    ? "${newsModelList[index].content?.substring(0, 55)}...."
                                                    : newsModelList[index]
                                                            .title ??
                                                        "",
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12),
                                              )
                                            ],
                                          )))
                                ],
                              )),
                        ),
                      );
                    } catch (e) {
                      //(e);
                      return Container();
                    }
                  }),
        ]),
      ),
    );
  }
}
