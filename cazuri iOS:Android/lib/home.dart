import 'package:flutter/material.dart';
import 'infopage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

DateTime now = DateTime.now();
String formattedDate = DateFormat('MM-dd-yyyy - kk:mm').format(now);

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Map worldData;

  fetchWorldWideData() async {
    http.Response response =
        await http.get('https://disease.sh/v3/covid-19/all');
    setState(() {
      worldData = json.decode(response.body);
    });
  }

  @override
  void initState() {
    fetchWorldWideData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5f5ff),
      body: Stack(
        children: <Widget>[
          ClipPath(
            clipper: MyClipper(),
            child: Container(
              height: 350,
              decoration: BoxDecoration(
                color: Color(0xffa3a7e4),
              ),
            ),
          ),
          Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 35, 20, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.all(10),
                      child: Image.asset(
                        'asset/Menu.png',
                        height: 30,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Container(
                      child: Image.asset(
                        'asset/Search.png',
                        height: 30,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: Row(
                  children: <Widget>[
                    Container(
                      child: Image.asset(
                        'asset/Coughing.png',
                        height: 160,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Container(
                      height: 220,
                      width: 200,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          SizedBox(
                            height: 45,
                          ),
                          Text(
                            'Cazuri la nivel mondial',
                            style: TextStyle(
                                fontSize: 19,
                                color: Colors.white,
                                fontWeight: FontWeight.w900),
                            textAlign: TextAlign.right,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            formattedDate,
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            worldData['cases'].toString(),
                            style: TextStyle(
                              fontSize: 30,
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Column(
            children: <Widget>[
              SizedBox(
                height: 245,
              ),
              statsCard("Cazuri active", worldData['active'].toString(), 1, 2),
              statsCard("Vindecat", worldData['recovered'].toString(), 8, 7),
              statsCard("Decese", worldData['deaths'].toString(), 5, 4),
              Padding(
                padding: EdgeInsets.fromLTRB(25, 25, 25, 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Sfaturi',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 70,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: <Widget>[
                    SizedBox(
                      width: 25,
                    ),
                    requirementCard("asset/Glovesicon.png", "Manuşi"),
                    requirementCard("asset/Maskicon.png", "Masca"),
                    requirementCard("asset/Alcoholicon.png", "Alcool SNT"),
                  ],
                ),
              ),
              Spacer(),
              Card(
                margin: EdgeInsets.symmetric(horizontal: 10),
                shape: StadiumBorder(),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    pageelements(Icon(Icons.bar_chart), "Stats"),
                    pageelements(Icon(Icons.map), "Nearby"),
                    pageelements(Icon(Icons.new_releases_sharp), "News"),
                    GestureDetector(
                      child: pageelements(Icon(Icons.info), "Info"),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => InfoPage()),
                        );
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

Widget pageelements(Icon icon, String label) {
  return Container(
    margin: EdgeInsets.all(4),
    child: Column(
      children: <Widget>[
        Container(
          child: icon,
        ),
        SizedBox(
          height: 4,
        ),
        Text(label),
      ],
    ),
  );
}

class MyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height - 80);
    path.quadraticBezierTo(
        size.width / 2, size.height, size.width, size.height - 80);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}

Widget statsCard(String title, String count, int p1, int p2) {
  return Card(
      shadowColor: Colors.black87,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      margin: EdgeInsets.fromLTRB(20, 20, 20, 10),
      child: Padding(
        padding: EdgeInsets.fromLTRB(25, 20, 10, 20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    title,
                    style: TextStyle(
                      color: Color(0xff7777ff),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    count,
                    style: TextStyle(
                      fontSize: 25,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 70,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: [
                      Icon(
                        Icons.arrow_downward,
                        size: 15,
                        color: Colors.green,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        "+$p1%",
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.arrow_upward,
                        size: 20,
                        color: Colors.red,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        "+$p2%",
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ));
}

Widget requirementCard(String img, String label) {
  return Padding(
    padding: EdgeInsets.all(1.0),
    child: Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: EdgeInsets.only(
        right: 20,
      ),
      child: Padding(
        padding: EdgeInsets.all(15),
        child: Row(
          children: <Widget>[
            Container(
              child: Image.asset(img),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              label,
              style: TextStyle(
                color: Color(0xff7777ff),
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
