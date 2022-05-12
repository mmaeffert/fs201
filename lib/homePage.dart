import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'drawer.dart';
import './appbar.dart' as ab;
import 'orderPageByEmre.dart';
import 'themes.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Color whiteColor = Color.fromRGBO(242, 242, 242, 1);
  var hi = ab.GetCurrentUser().getUser()!.displayName.toString();
  drawer drawerObj = new drawer();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(onRefresh: () async {
        debugPrint("refresh ");
      },
        child: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            iconTheme: IconThemeData(color: whiteColor),
            bottom: PreferredSize(
              // Add this code
              preferredSize: Size.fromHeight(40.0), // Add this code
              child: Text(''), // Add this code
            ),
            floating: false,
            pinned: true,
            snap: false,
            backgroundColor: CustomTheme.isDarkTheme
                ? CustomTheme.darkTheme.primaryColor
                : CustomTheme.lightTheme.primaryColor,
            expandedHeight: 180.0,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding:
                  EdgeInsets.symmetric(vertical: 16.0, horizontal: 20),
              background: Stack(children: [
                Positioned.fill(
                    child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 160,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(
                              "https://image.brigitte.de/11481458/t/4H/v3/w1440/r1.7778/-/butter-broetchen-bild.jpg",
                            ),
                            fit: BoxFit.cover,
                            colorFilter: ColorFilter.mode(
                                Colors.black.withOpacity(0.3),
                                BlendMode.darken),
                          ),
                        )))
              ]),
              title: Container(
                margin: EdgeInsets.only(top: 0),
                child: ab.GetCurrentUser().getUser() != null
                    ? Text(
                        "Hallo " +
                            ab.GetCurrentUser()
                                .getUser()!
                                .displayName
                                .toString() +
                            "!",
                        style: GoogleFonts.lato(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: whiteColor),
                      )
                    : Text(
                        "Hallo Gast",
                        style: GoogleFonts.lato(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: whiteColor),
                      ),
              ),
            ),
            actions: <Widget>[
              Container(
                  margin: EdgeInsets.only(right: 12),
                  child: Container(
                    margin: EdgeInsets.only(right: 5),
                    //  width: 37,
                    child: ab.Appbar.showUserProfile(),
                  ))
            ],
          ),
          SliverToBoxAdapter(
            child: Container(
              margin: EdgeInsets.only(top: 30, left: 20, right: 20),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height-150,
              child:Column(
crossAxisAlignment: CrossAxisAlignment.start,
                  children:[
                  Scrollbar(

                child: SingleChildScrollView(

    scrollDirection: Axis.horizontal,
    child:
    Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    //_____
                    Container(
                      width: 210,
                      height: 145,
                      margin: EdgeInsets.only(right: 30, bottom: 10),
                      decoration: BoxDecoration(
                          /*
                        boxShadow: [
                          BoxShadow(
                            color: Colors.yellow.shade500.withOpacity(0.3),
                            spreadRadius: 1,
                            blurRadius: 1,
                            offset: Offset(0, 4), // changes position of shadow
                          ),


                        ], */
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          gradient: LinearGradient(
                            colors: [
                              Colors.yellow,
                              Colors.yellow.shade600,
                              Colors.yellow.shade300,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          )),
                      child: InkWell(
                          splashColor: Colors.blue.withAlpha(30),
                          onTap: () {
                            debugPrint('Card tapped.');
                          },
                          child: Container(
                            child: Stack(
                              children: [
                                Positioned(
                                    right: 70,
                                    top: 35,
                                    child: Icon(
                                      Icons.account_balance_sharp,
                                      size: 70,
                                      color: Color.fromRGBO(242, 242, 242, 0.8),
                                    )),
                                Positioned(
                                    right: 15,
                                    top: 15,
                                    child: Text(
                                      "3.50 €",
                                      style: GoogleFonts.lato(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        /* shadows: <Shadow>[
                                      Shadow(
                                        offset: Offset(0.0, 2.0),
                                        blurRadius: 1.0,
                                        color: Color.fromARGB(255, 0, 0, 0).withOpacity(0.4),
                                      ),

                                    ],


                                    */
                                      ),
                                    )),
                                Positioned(
                                  bottom: 10,
                                  left: 15,
                                  child: Text(
                                    "Guthaben aufladen",
                                    style: GoogleFonts.lato(
                                        color: Colors.white,
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                          )),
                    ),

                    //_____________________


                    Container(
                      margin: EdgeInsets.only(right: 30, bottom: 10),

                      width: 210,
                      height: 145,
                      decoration: BoxDecoration(
                        /*
                        boxShadow: [
                          BoxShadow(
                            color: Colors.yellow.shade500.withOpacity(0.3),
                            spreadRadius: 1,
                            blurRadius: 1,
                            offset: Offset(0, 4), // changes position of shadow
                          ),


                        ], */
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          gradient: LinearGradient(
                            colors: [
                              Colors.purple,
                              Colors.purple.shade600,
                              Colors.purple.shade300,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          )),
                      child: InkWell(
                          splashColor: Colors.blue.withAlpha(30),
                          onTap: () {
                            debugPrint('Card tapped.');
                          },
                          child: Container(
                            child: Stack(
                              children: [
                                Positioned(
                                    right: 70,
                                    top: 35,
                                    child: Icon(
                                      Icons.receipt_long_outlined,
                                      size: 70,
                                      color: Color.fromRGBO(242, 242, 242, 0.8),
                                    )),
                                Positioned(
                                    right: 20,
                                    top: 15,
                                    child: Text(
                                      "",
                                      style: GoogleFonts.lato(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        /* shadows: <Shadow>[
                                      Shadow(
                                        offset: Offset(0.0, 2.0),
                                        blurRadius: 1.0,
                                        color: Color.fromARGB(255, 0, 0, 0).withOpacity(0.4),
                                      ),

                                    ],


                                    */
                                      ),
                                    )),
                                Positioned(
                                  bottom: 10,
                                  left: 15,
                                  child: Text(
                                    "Bestellhistorie",
                                    style: GoogleFonts.lato(
                                        color: Colors.white,
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                          )),
                    ),

                    //______________
                    Container(
                      margin: EdgeInsets.only(right: 0, bottom: 10),

                      width: 210,
                      height: 145,
                      decoration: BoxDecoration(
                        /*
                        boxShadow: [
                          BoxShadow(
                            color: Colors.yellow.shade500.withOpacity(0.3),
                            spreadRadius: 1,
                            blurRadius: 1,
                            offset: Offset(0, 4), // changes position of shadow
                          ),


                        ], */
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          gradient: LinearGradient(
                            colors: [
                              Colors.grey,
                              Colors.grey.shade600,
                              Colors.grey.shade300,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          )),
                      child: InkWell(
                          splashColor: Colors.blue.withAlpha(30),
                          onTap: () {
                            debugPrint('Card tapped.');
                          },
                          child: Container(
                            child: Stack(
                              children: [
                                Positioned(
                                    right: 70,
                                    top: 35,
                                    child: Icon(
                                      Icons.history,
                                      size: 70,
                                      color: Color.fromRGBO(242, 242, 242, 0.8),
                                    )),
                                Positioned(
                                    right: 20,
                                    top: 15,
                                    child: Text(
                                      "",
                                      style: GoogleFonts.lato(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        /* shadows: <Shadow>[
                                      Shadow(
                                        offset: Offset(0.0, 2.0),
                                        blurRadius: 1.0,
                                        color: Color.fromARGB(255, 0, 0, 0).withOpacity(0.4),
                                      ),

                                    ],


                                    */
                                      ),
                                    )),
                                Positioned(
                                  bottom: 10,
                                  left: 15,
                                  child: Text(
                                    "Dauerauftrag",
                                    style: GoogleFonts.lato(
                                        color: Colors.white,
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                          )),
                    ),

//__________________________________


                  ],
                ),
              ),
            ),


                    Container(
                      margin: EdgeInsets.only(top: 30),

                      width: MediaQuery.of(context).size.width,
                      height: 145,
                      decoration: BoxDecoration(
                        /*
                        boxShadow: [
                          BoxShadow(
                            color: Colors.yellow.shade500.withOpacity(0.3),
                            spreadRadius: 1,
                            blurRadius: 1,
                            offset: Offset(0, 4), // changes position of shadow
                          ),


                        ], */
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          gradient: LinearGradient(
                            colors: [
                              Colors.blue,
                              Colors.blue.shade600,
                              Colors.blue.shade300,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          )),
                      child: InkWell(
                          splashColor: Colors.blue.withAlpha(30),
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) => OrderPage()));
                            debugPrint('Card tapped.');
                          },
                          child: Container(
                            child: Stack(
                              children: [
                                Positioned(
                                    right: 50,
                                    top: 35,
                                    child: Icon(
                                      Icons.shopping_basket_outlined,
                                      size: 70,
                                      color: Color.fromRGBO(242, 242, 242, 0.8),
                                    )),
                                Positioned(
                                    right: 20,
                                    top: 15,
                                    child: Text(
                                      "",
                                      style: GoogleFonts.lato(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        /* shadows: <Shadow>[
                                      Shadow(
                                        offset: Offset(0.0, 2.0),
                                        blurRadius: 1.0,
                                        color: Color.fromARGB(255, 0, 0, 0).withOpacity(0.4),
                                      ),

                                    ],


                                    */
                                      ),
                                    )),
                                Positioned(
                                  bottom: 10,
                                  left: 15,
                                  child: Text(
                                    "Bestellung aufgeben",
                                    style: GoogleFonts.lato(
                                        color: Colors.white,
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                          )),
                    ),


                  ]
                    )

          ),
          ),
        ],
      ),
      ),
      drawer: drawerObj.test(context),


    );
  }
}
