

import 'dart:io';

import 'package:car_milage/CarProfile.dart';
import 'package:car_milage/CarProfileManager.dart';
import 'package:car_milage/main.dart';
import 'package:car_milage/widget_library.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

import 'BasicElements.dart';

class CreateCarProfle extends StatefulWidget{

  State<MyHomePage> pg;
  CreateCarProfle(this.pg);

  @override
  CreateCarProfile_State createState() => CreateCarProfile_State(this);
}

class CreateCarProfile_State extends State<CreateCarProfle>{

  CreateCarProfle parent;
  List<ColorOption> color_choices = new List();
  ColorOption current_choice;
  static double color_option_radius = 15;
  static double color_option_box_size = 22;
  int car_style_pg_index = 0;

  TextEditingController nickname_c = new TextEditingController();
  TextEditingController year_c = new TextEditingController();
  TextEditingController millage_c = new TextEditingController();
  TextEditingController price_c = new TextEditingController();
  CarouselController car_style_c = new CarouselController();

  CreateCarProfile_State(this.parent){
    this.build_color_choices();
  }

  @override
  Widget build(BuildContext context) {
    double screen_height =  MediaQuery.of(context).size.height;
    double screen_width =  MediaQuery.of(context).size.width;

    Widget body_widget = ListView(
        children: [
          this.build_car_options(screen_height, screen_width),
          this.build_Color_Selector(),
          Padding(padding:  const EdgeInsets.symmetric(vertical: 5, horizontal: 15), child: TextEntry.simple_text_entry(this.nickname_c, hint: "Vechile Nickname")),
          Padding(padding:  const EdgeInsets.symmetric(vertical: 5, horizontal: 15), child: TextEntry.simple_text_entry(this.year_c, hint: "Model Year", only_numbers: true)),
          Padding(padding:  const EdgeInsets.symmetric(vertical: 5, horizontal: 15), child: TextEntry.simple_text_entry(this.millage_c, hint: "Millage", only_numbers: true)),
          Padding(padding:  const EdgeInsets.symmetric(vertical: 5, horizontal: 15), child: TextEntry.simple_text_entry(this.price_c, hint: "Purchase Price", only_numbers: true)),
          this.sumbit_button(50, 250)
          ]
      );

    // TODO: implement build
    return Scaffold(
      appBar: AppBar(title: Text("New Car Profile"),),
      body: new GestureDetector(
        onTap: () { FocusScope.of(context).requestFocus(new FocusNode()); },
        child: body_widget
      )
    );
  }
  /* CAR SELECTOR */
  Widget build_car_options(double h, double w){
    double height_factor = 0.4;
    List <Widget> options = new List();
    CarProfile.car_options.forEach((element) {
      options.add(Container(height: h, width: w,
        child: Center(child: Stack(children: [
          Image.asset(element['img'], fit: BoxFit.fitHeight,),
          Text(element['key']),
        ]))
      ));
    });

    return CarouselSlider(
        options: CarouselOptions(
          carouselController: this.car_style_c,
          height: h * height_factor,
          viewportFraction: 1.0,
          enlargeCenterPage: false,
          enableInfiniteScroll: false,
          onPageChanged: (index, reason) => this.car_style_pg_index = index,
          // autoPlay: false,
        ),
        items: options
      );
  }
  /* SUMBITTING SELECTion */
  void sumbit(dynamic n) {
    int milage = null;
    int year = null;
    double price = null;
    String nickname = "";
    nickname = this.nickname_c.text;
    try{
      year = int.parse(this.year_c.text);
    } catch(e){  }
    try{
      milage = int.parse(this.year_c.text);
    } catch(e){  }
    try{
      milage = double.parse(this.millage_c.text).floor();
    } catch(e){  }   
    if(this.price_c.text != ""){
      try{
        price = double.parse(this.price_c.text);
      } catch(e) { }
    }

    // error check
    if(milage == null || nickname == "" || year == null || (this.price_c.text != "" && price == null)){
      //send to error handler

      return;
    }
    //create obj
    CarProfile lcl = new CarProfile(nickname, milage, year, CarProfile.car_options[this.car_style_pg_index], this.current_choice.color);
    lcl.get_set_price(value: price);
    this.parent.pg.setState((){
      CarProfleManager.get_manager().add_profile(lcl);
    });
    //close page
    this.close_page(context);
  }
  Future close_page(context) async {
    Navigator.pop(context, true);
  }
  Widget sumbit_button(double h, double w){
    return Padding(padding: const EdgeInsets.all(32),
      child: ButtonsWidgets.rounded_button(h, w, this.sumbit, null, txt: 'Sumbit', bg_colour: Colors.amber, style: TextStyle(fontSize: 22, fontWeight: FontWeight.w200))
    );
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Center(
        child: Container(height: h, width: w,
          child: FlatButton(
            onPressed: ()=> this.sumbit(null),
            color: Colors.amberAccent,
            child: Text('Sumbit'),)
        ),
      ),
    );
  }
  /* COLOR SELECTOR */
  void build_color_choices(){
    CarProfile.colour_options.forEach((element) {
      color_choices.add(ColorOption(this, CreateCarProfile_State.color_option_box_size, CreateCarProfile_State.color_option_radius, element, new Boolean(false)));
    });
    this.color_choices[0].active.get_set_state(state:true);
    this.current_choice = this.color_choices[0];
  }

  void set_active_color(ColorOption choice){
    if(choice == this.current_choice)
      return;
    setState((){
      choice.active.get_set_state(state: true);
      this.current_choice.active.get_set_state(state: false);
      this.current_choice = choice;
    });
  }

  Widget build_Color_Selector(){
    List<Widget> items = new List();
    this.color_choices.forEach((element) {
      items.add(element.build());
    });
    return Align( alignment: Alignment.topCenter, child: Wrap(children:items,));
  }
}

