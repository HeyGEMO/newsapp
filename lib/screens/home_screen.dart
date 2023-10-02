import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:newsapp/category.dart';
import 'package:newsapp/screens/loginPage.dart';
import 'package:newsapp/screens/bookmarkPage.dart';
import 'package:newsapp/models/news_models.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:newsapp/screens/details_screen.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController searchController = new TextEditingController();
  List<NewsData> newsModelList = <NewsData>[];
  List<NewsData> newsModelListCarousel = <NewsData>[];
  List<String> navBarItem = [
    "General",
    "Business",
    "Entertainment",
    "Technology",
    "Sports",
    "Health",
  ];

//for recent news
  bool isLoading = true;
  getNewsByQuery(String query) async {
    String url =
        "https://newsapi.org/v2/everything?q=apple&from=2023-09-24&to=2023-09-24&sortBy=popularity&apiKey=aaf6c84c087b4b9ba8c41e65aef6074f";
    Response response = await get(Uri.parse(url));
    Map data = jsonDecode(response.body);
    setState(() {
      data["articles"].forEach((element) {
        NewsData newsQueryModel = new NewsData();
        newsQueryModel = NewsData.fromMap(element);
        newsModelList.add(newsQueryModel);
        setState(() {
          isLoading = false;
        });

      });
    });
  }

//for breaking news
   getNewsofNepal() async {
    String url = "https://newsapi.org/v2/top-headlines?country=in&apiKey=9bb7bf6152d147ad8ba14cd0e7452f2f";
    Response response = await get(Uri.parse(url));
    Map data = jsonDecode(response.body);
    setState(() {
      data["articles"].forEach((element) {
        NewsData newsQueryModel = new NewsData();
        newsQueryModel = NewsData.fromMap(element);
        newsModelListCarousel.add(newsQueryModel);
        setState(() {
          isLoading = false;
        });
      });
    });
  }
  
  List categoryList=["General","Business","Entertainment","Technology","Sports","Health"];

  late ScrollController _controller;
  bool _isAccept =false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getNewsByQuery("lauda");
    getNewsofNepal();

    _controller=ScrollController()..addListener(_reachUp);
  }

  int _index=0;


@override
void dispose(){
  _controller.dispose();
  super.dispose();
}
void _reachUp(){
  if(_controller.offset<=_controller.position.maxScrollExtent && !_controller.position.outOfRange){
    _isAccept=true;
    setState(() {
      
    });
  }
}



  @override
  Widget build(BuildContext context) {
     final screen=[
    Homescreen(searchController: searchController, isLoading: isLoading, newsModelListCarousel: newsModelListCarousel, newsModelList: newsModelList),
    BookmarkPage(),
    LoginPage(),
  ];
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.blueGrey,
        title: Text(
          "NewsApp",
          style: TextStyle(color: Color.fromARGB(255, 2, 247, 255),fontWeight: FontWeight.bold),
        ),

        //Notification button

        // actions: [
        //   IconButton(
        //       onPressed: () {},
        //       icon: Icon(
        //         Icons.notifications_outlined,
        //         color: Colors.black,
        //       ))
        // ],
      ),
      
      //news category
    drawer: Drawer(
        child:
        Column(
          children: [
            Container( 
              height: 60,
              width: 304,
              decoration: BoxDecoration(
                color: Colors.blueGrey,
              ),
              child: 
                SafeArea(
                  child: Text("CATEGORY",style: GoogleFonts.lato(
                  textStyle: Theme.of(context).textTheme.displayMedium,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,),
                              ),
                ),
              
            ),
            SizedBox(height: 10,),
            ListView.builder(
              shrinkWrap: true,
              itemCount: categoryList.length,

              controller: _controller,

             itemBuilder: (context, index) {
              return ListTile(
                    title: Text(categoryList[index],style: GoogleFonts.lato(
    textStyle: Theme.of(context).textTheme.displayMedium,
    fontSize: 20,
    fontWeight: FontWeight.w700,
    fontStyle: FontStyle.italic,
  ),),
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>category(query: navBarItem[index])));
                    },
               );
             }
                
  //           UserAccountsDrawerHeader(
  //             accountName: Text("USER",style: GoogleFonts.lato(
  //   textStyle: Theme.of(context).textTheme.displayMedium,
  //   fontSize: 30,
  //   fontWeight: FontWeight.w700,
  //   fontStyle: FontStyle.italic,
  // ),), 
  //             accountEmail:Text("bakchod@gmail.com")
  //             ),
                 
            ),
          ],
        ),
      ),
 
      //work on body 
      body:screen.elementAt(_index),
      
      
      //navigation button bar float
      
      bottomNavigationBar: Container(
        margin: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(16),
        ),
        child: BottomNavigationBar(
          currentIndex: _index,
          onTap: (value){
            setState(() {
              _index=value;
            });
          },
          elevation: 0.0,
          selectedItemColor: Colors.orange.shade900,
          items: [
            BottomNavigationBarItem(
              backgroundColor: Colors.transparent,
              icon: Icon(Icons.home),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bookmark),
              label: "Bookmark",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: "Profile",
            ),
          ],
          
          )
        ),
    );
  }
}

class Homescreen extends StatelessWidget {
  const Homescreen({
    super.key,
    required this.searchController,
    required this.isLoading,
    required this.newsModelListCarousel,
    required this.newsModelList,
  });

  final TextEditingController searchController;
  final bool isLoading;
  final List<NewsData> newsModelListCarousel;
  final List<NewsData> newsModelList;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
           Container(
      //Search ko Container ho
      padding: EdgeInsets.symmetric(horizontal: 8),
      margin: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24)),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              if ((searchController.text).replaceAll(" ", "") ==
                  "") {
                print("Search");
              } else {
               Navigator.push(context, MaterialPageRoute(builder: (context) => category(query: searchController.text)));
              }
            },
            child: Container(
              child: Icon(
                Icons.search,
                color: Colors.blueAccent,
              ),
              margin: EdgeInsets.fromLTRB(3, 0, 7, 0),
            ),
          ),
          Expanded(
            child: TextField(
              controller: searchController,
              textInputAction: TextInputAction.search,
              onSubmitted: (value){
                if(value==""){
                  print("Blank Search");
                }
                else{
                Navigator.push(context, MaterialPageRoute(builder: (context) => category(query: value)));
              }
              },
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Search News"),
            ),
          ),
        ],
      )
      ),
          Container(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Breaking News",
                    style: TextStyle(
                      color: const Color.fromARGB(255, 197, 32, 20),
                      fontSize: 26.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),

                  // caroussel screen
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 15),
                    child: isLoading ? Container(height:200,child: Center(child: CircularProgressIndicator())) : CarouselSlider(
                      options: CarouselOptions(
                  height: 200, autoPlay: true, enlargeCenterPage: true),
                         items: newsModelListCarousel.map((instance) {
                return Builder(builder: (BuildContext context) {

                  try{

                  return InkWell(
                    onTap: () {
                      Navigator.push(context,MaterialPageRoute(builder: (context)=>DetailsScreen(data: instance,)));
                    },
                    child: Container(
                  
                      child : Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)
                        ),
                        child : Stack(
                          children : [
                            ClipRRect(
                              borderRadius : BorderRadius.circular(10),
                              child : Image.network(instance.urlToImage ?? "" , fit: BoxFit.fitHeight, width: double.infinity,)
                            ) ,
                            Positioned(
                              left: 0,
                                right: 0,
                                bottom: 0,
                                child: Container(
                                  
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.black12.withOpacity(0),
                                        Colors.black
                                      ],
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter
                                    )
                                  ),
                              child : Container(
                                padding: EdgeInsets.symmetric(horizontal: 5 , vertical: 10),
                                child:Container( margin: EdgeInsets.symmetric(horizontal: 10), child: Text(instance.title ?? "" , style: TextStyle(fontSize: 18 , color: Colors.white , fontWeight: FontWeight.bold),))
                              ),
                              )
                            ),
                          ]
                        )
                      )
                    ),
                  );
                  }

                  catch(e){
                    print(e); 
                    return Container();
                    }

                });
              }).toList(),
            ),
          ),
                  
                  //recent news part
                  Container(
            child: Column(
              children: [
                Container(
                  margin : EdgeInsets.fromLTRB(15, 25, 0, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [

                      Text("LATEST NEWS " , style: TextStyle(fontWeight: FontWeight.bold , fontSize: 28
                      ),),
                    ],
                  ),
                ),
                isLoading ? Container(height: MediaQuery.of(context).size.height-350,child: Center(child: CircularProgressIndicator())): 
                ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: newsModelList.length,
                    itemBuilder: (context, index) {

try{

                      return Container(
                        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(context,MaterialPageRoute(builder: ((context) => DetailsScreen(data:newsModelList[index],))));
                          },
                          child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                              elevation: 1.0,
                              child: Stack(
                                children: [
                                  ClipRRect(
                                      borderRadius: BorderRadius.circular(15),
                                      child: Image.network(newsModelList[index].urlToImage ?? "" ,fit: BoxFit.fitHeight, height: 230,width: double.infinity, )),
                        
                                  Positioned(
                                      left: 0,
                                      right: 0,
                                      bottom: 0,
                                      child: Container(
                        
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(15),
                                          gradient: LinearGradient(
                                            colors: [
                                              Colors.black12.withOpacity(0),
                                              Colors.black
                                            ],
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter
                                          )
                                        ),
                                        padding: EdgeInsets.fromLTRB(15, 15, 10, 8),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                newsModelList[index].title ?? "",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold),
                                              ),
                                              Text(newsModelList[index].content!.length > 50 ? "${newsModelList[index].content?.substring(0,55)}...." : newsModelList[index].title ??"" , style: TextStyle(color: Colors.white , fontSize: 12)
                                                ,)
                                            ],
                                          )))
                                ],
                              )),
                        ),
                      );

                      }
                      catch(e){
                        print(e); 
                        return Container();
                        }
                    }
                    ),
   ]
    )
                
    )
     ]
    )
    )
    )
    ]
    )
    );
  }
}
