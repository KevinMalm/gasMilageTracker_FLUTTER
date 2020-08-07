import 'package:car_milage/CarProfile.dart';
import 'package:car_milage/widget_library.dart';
import 'package:flutter/material.dart';

import 'BasicElements.dart';
import 'main.dart';



class GasFuelUpPage extends StatefulWidget{

  MyHomePageState pg;
  CarProfile lcl_profile;
  GasFuelUpPage(this.pg, this.lcl_profile);

  @override
  GasFuelUpPage_State createState() => GasFuelUpPage_State(this);
}

class GasFuelUpPage_State extends State<GasFuelUpPage>{
  TextEditingController new_milage_c = new TextEditingController();
    double milage = null;
    double delta_milage = null;
  TextEditingController total_gallons_c = new TextEditingController();
    double total_gallons = null;
    double delta_gallons = null;
  TextEditingController pp_g_c = new TextEditingController();
    double pp_g = null;
    double ppg_delta = null;

  double mpg = null;
  double delta_mpg = null;
  GasFuelUpPage parent;
  Date lcl_date;
  int delta_days = null;

  String mpg_str = " - ";
  String delta_mpg_str = "- ";
  String delta_gallons_str = ' - ';
  String pp_g_str = ' - ';
  String delta_miles_str = ' - ';
  String delta_days_str = ' - ';

  GasFuelUpPage_State(this.parent){
    this.lcl_date = Date.now();
  } 

  void update_UI(){
    print('Changed!');
    this.setState(() { 
      this.milage = GasFuelUpPage_State.get_txt_conversion(this.new_milage_c);
      this.pp_g = GasFuelUpPage_State.get_txt_conversion(this.pp_g_c);
      this.total_gallons = GasFuelUpPage_State.get_txt_conversion(this.total_gallons_c);

      //Delta Days 
      if(this.parent.lcl_profile.prev_record != null && this.parent.lcl_profile.prev_record.get_date() != null){
        DateTime last_record = this.parent.lcl_profile.prev_record.get_date().to_datetime();
        DateTime this_record = this.lcl_date.to_datetime();
        this.delta_days = this_record.difference(last_record).inDays;
        this.delta_days_str = (this.delta_days > 0 ? "+": "") + this.delta_days.toString() + " Days";
      } else {
        this.delta_days_str = ' - ';
      }
      //MILAGE 
      if(this.milage != null){
        this.delta_milage = (this.parent.lcl_profile.current_millage() == null) ? this.milage : (this.milage - this.parent.lcl_profile.current_millage());
        this.delta_miles_str = this.delta_milage.toStringAsFixed(0) + " Miles";
      } else {
        this.delta_miles_str = ' - ';
      }    

      //CHANGE IN PPG
      if(this.pp_g != null && this.parent.lcl_profile.prev_record != null && this.parent.lcl_profile.prev_record.get_price_per_gallon() != null){
        this.ppg_delta = (this.pp_g - this.parent.lcl_profile.prev_record.get_price_per_gallon().toDouble());
        this.pp_g_str = ((this.ppg_delta > 0) ? "+" : "") + this.ppg_delta.toStringAsFixed(2) + " USD";
      } else {
        this.pp_g_str = ' - ';
      }

      //CHANGE GALLON CONSUMPTION
      if(this.total_gallons != null && this.parent.lcl_profile.prev_record != null && this.parent.lcl_profile.prev_record.get_gallons() != null){
        this.delta_gallons = (this.total_gallons- this.parent.lcl_profile.prev_record.get_gallons());
        this.delta_gallons_str = ((this.delta_gallons > 0) ? "+" : "") + this.delta_gallons.toStringAsFixed(2) + " gal";
      } else {
        this.delta_gallons_str = ' - ';
      }

      //LAST MPG 
      if(this.delta_milage != null &&  this.total_gallons != null && this.parent.lcl_profile.prev_record != null && this.parent.lcl_profile.prev_record.get_gallons() != null) {
        this.mpg = (this.delta_milage / this.total_gallons);
        this.mpg_str = this.mpg.toStringAsFixed(2) + " MPG";
      } else
        this.mpg_str = ' - ';
      //DELTA MPG 
      if(this.mpg != null && this.parent.lcl_profile.prev_record != null && this.parent.lcl_profile.prev_record.get_mpg() != null) {
        this.delta_mpg = (this.mpg - this.parent.lcl_profile.prev_record.get_mpg());
        this.delta_mpg_str = ((this.delta_mpg > 0) ? "+" : "") + this.delta_mpg.toStringAsFixed(2) + " MPG";
      } else
        this.delta_mpg_str = ' - ';
    });
  }

  static double get_txt_conversion(TextEditingController _c){
    double a = null;
    if(_c.text == '')
      return null;
    try{
      a = double.parse(_c.text);
    } catch(e) { }
    return a;
  }

  Widget build_updates_area(double h, double w){

    print(this.delta_miles_str);
    return Container(
      height: h, width: w,
      child: Wrap(
        alignment: WrapAlignment.spaceAround,
        spacing: 5,
        children: [ //miles +, mpgs, delta mpg, delta price, price per gallon 
          Boxes.build_soft_container(h / 3.2, w / 1.5, Colors.amber, Center(child:Text(this.delta_days_str, style:TextStyle(fontWeight: FontWeight.w200, color: Colors.white, fontSize: 32),))),
          Boxes.build_soft_container(h / 3.2, w / 2.1, Colors.amber, Center(child:Text(this.delta_miles_str, style:TextStyle(fontWeight: FontWeight.w200, color: Colors.white, fontSize: 32),))),
          Boxes.build_soft_container(h / 3.2, w / 2.1, Colors.amber, Center(child:Text(this.delta_gallons_str, style:TextStyle(fontWeight: FontWeight.w200, color: Colors.white, fontSize: 28),))),
          Boxes.build_soft_container(h / 3.4, w / 3.4, Colors.amber, Center(child:Text(this.mpg_str, style:TextStyle(fontWeight: FontWeight.w200, color: Colors.white, fontSize: 22)))),
          Boxes.build_soft_container(h / 3.4, w / 3.4, Colors.amber, Center(child:Text(this.delta_mpg_str, style:TextStyle(fontWeight: FontWeight.w200, color: Colors.white, fontSize: 22)))),
          Boxes.build_soft_container(h / 3.4, w / 3.4, Colors.amber, Center(child:Text(this.pp_g_str, style:TextStyle(fontWeight: FontWeight.w200, color: Colors.white, fontSize: 22)))),
      ],));

  }

  void sumbit_record(dynamic args){

    if(this.milage == null || this.total_gallons == null || this.pp_g == null){
      print('Error');
      return;
    }
    double cost = (this.pp_g * this.total_gallons);
    GasRecord new_record = new GasRecord(this.lcl_date, cost, this.total_gallons, this.pp_g, this.milage.floor(), this.parent.lcl_profile.prev_record, this.mpg);
    this.parent.pg.setState(() {
      this.parent.lcl_profile.addGasRecord(new_record);
    });
    this.close_page(args);
    return;
  }

  Future close_page(context) async {
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    double screen_width =  MediaQuery.of(context).size.width;
    double screen_height=  MediaQuery.of(context).size.height;
  
    //Widget date_txt = Center(child: Text(this.lcl_date.toString(), style: TextStyle(color: Colors.black12)));
    Widget page = Column(children: [
      Center(child: DateSelector.build_date_selector(context, this, this.lcl_date, 50, 300)),
      Padding(padding:  const EdgeInsets.symmetric(vertical: 5, horizontal: 15), child: TextEntry.simple_text_entry(this.new_milage_c, hint: "Current Milage", onTxtChange: this.update_UI)),
      Padding(padding:  const EdgeInsets.symmetric(vertical: 5, horizontal: 15), child: TextEntry.simple_text_entry(this.total_gallons_c, hint: "Total Gallons", onTxtChange: this.update_UI)),
      Padding(padding:  const EdgeInsets.symmetric(vertical: 5, horizontal: 15), child: TextEntry.simple_text_entry(this.pp_g_c, hint: "USD / gal", onTxtChange: this.update_UI)),
      this.build_updates_area(200, screen_width)
    ],);
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(title: Text(this.parent.lcl_profile.getNickName()),),
      body: new GestureDetector(
        onTap: () { FocusScope.of(context).requestFocus(new FocusNode()); },
        child: Stack( children: [
          page,
          Align(alignment: Alignment.bottomCenter, child: Padding(
            padding: const EdgeInsets.only(bottom: 32.0),
            child: ButtonsWidgets.rounded_button(50, 170, this.sumbit_record, context, bg_colour: Colors.amber, txt: 'Submit', style: const TextStyle(fontSize: 22, color: Colors.white, fontWeight: FontWeight.w200)),
          ))
        ])
      )
    );
  }
  

  static String get_record_values(double a, double b, String trailing, {bool decimal = true}) {
    if(a == null || b == null)
      return '-';
    String str = '+ ';
    double v = a - b;
    if(v < 0) {
      str = '- ';
      v *= -1;
    }
    if(decimal)
      return str + v.toStringAsFixed(2) + " "  + trailing;
    return str + v.toStringAsFixed(0) + " "  + trailing;
  }
}

/*
if(this.parent.lcl_profile.prev_record != null) {
      if(current_miles != null && this.parent.lcl_profile.get_current_millage() != null){
        delta_miles = current_miles - this.parent.lcl_profile.get_current_millage();
        //delta_miles_str = "+" + delta_miles.toStringAsFixed(0) + " miles";
      }
      if(gallons != null && delta_miles != null) {
        mpg_str = (delta_miles / gallons).toStringAsFixed(2) + " mpg";
        double last_mpgs = this.parent.lcl_profile.get_last_record().get_mpg();
        if(last_mpgs != null) {
          if(last_mpgs < 0) {
            delta_mpg_str = "- ";
          } else {
            delta_mpg_str = "+ ";
          }
          delta_mpg_str += last_mpgs.toStringAsFixed(2);
        } else {
          delta_mpg_str = ' - ';
        }
      }

      if(gallons != null && this.parent.lcl_profile.prev_record.get_gallons() != null){
        double delta = gallons - this.parent.lcl_profile.prev_record.get_gallons();
        if(delta < 0) {
          delta_gallons_str = "- " + delta.toStringAsFixed(2) + " gals";
        } else {
          delta_gallons_str = "+ " + delta.toStringAsFixed(2) + " gals";
        }
      }
      if(this.parent.lcl_profile.prev_record.get_price_per_gallon() != null && usd_per_gal != null) {
        double delta = usd_per_gal - this.parent.lcl_profile.prev_record.get_price_per_gallon();
        if(delta < 0) {
          delta_gallons_str = "- " + delta.toStringAsFixed(2) + " USD";
        } else {
          delta_gallons_str = "+ " + delta.toStringAsFixed(2) + " USD";
        }
      }

    }



*/