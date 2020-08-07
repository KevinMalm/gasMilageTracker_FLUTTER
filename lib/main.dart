import 'package:car_milage/CarProfile.dart';
import 'package:car_milage/CarProfileManager.dart';
import 'package:car_milage/page_GasFillUp.dart';
import 'package:car_milage/page_NewCarProfile.dart';
import 'package:car_milage/page_NewOtherRecord.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.amber,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Car Records'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {

  void create_new_profile() {
    Navigator.push(
      context, 
      MaterialPageRoute(
        builder: (context) => CreateCarProfle(this)
      )
    );
  }
  void open_fuel_up_page(CarProfile profile){
    Navigator.push(
      context, 
      MaterialPageRoute(
        builder: (context) => GasFuelUpPage(this, profile)
      )
    );
  }
  void open_new_record_page(CarProfile profile){
    Navigator.push(
      context, 
      MaterialPageRoute(
        builder: (context) => OtherRecordPage(this, profile)
      )
    );
  }
  @override
  Widget build(BuildContext context) {
    double screen_width =  MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        child: CarProfleManager.get_manager().build_list(screen_width, this),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => create_new_profile(),
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
        
        
