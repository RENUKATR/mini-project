
import 'package:flutter/material.dart';
//import 'package:geo/current_location_screen.dart';
import 'package:geolocator/geolocator.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:permission_handler/permission_handler.dart';
//import 'package:geo/map23.dart';
import 'package:geo/mymap.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const login());
}


class login extends StatelessWidget {
  const login({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
   //   title: 'Flutter Demo',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Buswhere'),
    );
  }
}
String col=" ";
int i=0,j=0,k=0,l=0;
final geo = Geoflutterfire();
final List<GeoPoint> arr = [];
final List<GeoPoint> brr = [];

GeoPoint w = new GeoPoint(0,0);

double sum=0;
double lat=0, long=0;




class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}


class _MyHomePageState extends State<MyHomePage> {
  // int _counter = 0;
  String col = "";

  // final loc.Location location = loc.Location();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        title: Text(widget.title),
      ),
      body: Center(

        child: Column(

          children: [
            const Padding(padding: EdgeInsets.all(25), child:
            Text('Choose Bus ',style:
            TextStyle(color: Colors.blue, backgroundColor: Colors.white,fontWeight: FontWeight.bold,fontSize: 22),),),

            ElevatedButton(
                child: const Text("Bus 1", textAlign: TextAlign.center),
                onPressed: () {
                  col = "Bus 1";
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SecondScreen( "Bus 1"),
                    ),
                  );
                }
            ),
          ],
        ),
      ),
    );
  }

}



class SecondScreen extends StatelessWidget {

  final String str;

  const SecondScreen(this.str, {Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        ),
        body: Center(
          child: Column(
            children: [
              ElevatedButton(
                  child: const Text(
                      "share location", textAlign: TextAlign.center),
                  onPressed: () {
                    _requestPermission( str );

                    final snackBar = SnackBar(
                      content: const Text('done'),
                      action: SnackBarAction(
                        label: 'Undo',
                        onPressed: () {
                          // Some code to undo the change.
                        },
                      ),
                    );

                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
              ),

              ElevatedButton(
                  child: const Text("track bus", textAlign: TextAlign.center),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => srr()));
                  }
              )
            ],
          ),
        )
    );
  }

  _requestPermission(str) async {
    var status = await Permission.location.request();
    if (status.isGranted) {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      print('done');

      GeoFirePoint myLoc = geo.point(
          latitude: position.latitude,
          longitude: position.longitude);

      await FirebaseFirestore.instance.collection("Bus 1").add({'location': myLoc.data
      });

      // ThirdScreen(myLoc,  "Bus 1");
    }
    else if (status.isDenied) {
      _requestPermission(str);
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
    }
  }

}


class srr extends StatelessWidget {

  const srr() : super();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('buswhere tracker'),
      ),
      body: Column(
        children: [
          // TextButton(
          //     onPressed: () {
          //       _listenLocation();
          //     },
          //     child: Text(' ')),
          TextButton(
              onPressed: () {
                //   _stopListening();
              },
              child: Text('')),
          Expanded(
              child: StreamBuilder(
                stream:
                FirebaseFirestore.instance.collection('location').snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }
                  return ListView.builder(
                      itemCount: snapshot.data?.docs.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title:
                          Text(snapshot.data!.docs[index]['name'].toString()),
                          subtitle: Row(
                            children: [
                              Text(snapshot.data!.docs[index]['latitude']
                                  .toString()),
                              SizedBox(
                                width: 20,
                              ),
                              Text(snapshot.data!.docs[index]['longitude']
                                  .toString()),
                            ],
                          ),
                          trailing: IconButton(
                            icon: Icon(Icons.directions),
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      MyMap(snapshot.data!.docs[index].id)));
                            },
                          ),
                        );
                      });
                },
              )),

        ],
      ),
    );
  }
}


// ThirdScreen(myloc,str) async {
//     lat += myloc.getLatitude();
//    long += myloc.getLongitude();
//
//    if (i >= 3) {
//       QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection("Bus 1").get();
//
//       for (var doc in querySnapshot.docs) {
//         arr.add(doc['geopoint']);
//       };
//     }
//     int x = arr.length;
//
//    double la_v= lat/x;
//    double lo_av = long/x;
//
//     GeoPoint av_geo = new GeoPoint(la_v,lo_av);
// }
//


