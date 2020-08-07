

import 'package:car_milage/BasicElements.dart';
import 'package:car_milage/page_GasFillUp.dart';
import 'package:car_milage/page_NewCarProfile.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:bezier_chart/bezier_chart.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:carousel_slider/carousel_slider.dart';


import 'CarProfile.dart';
import 'main.dart';

class TextEntry{
  static void TRASH(){

  }

  static Widget simple_text_entry(TextEditingController _c, {String hint = "", bool only_numbers = false, Color colour = Colors.black, double font_size = 22, FontWeight weight = FontWeight.w300, Function onTxtChange = TextEntry.TRASH, bool boxed_in: true, double h = 70, double w = 400, Color bg_color = const Color.fromARGB(255, 250, 250, 250)}){
    Widget text =  TextField(
      controller: _c,
      style: TextStyle(color: colour, fontSize: font_size, fontWeight: weight),
      decoration: InputDecoration(
        labelText: hint,
        labelStyle: TextStyle(fontSize: font_size),
        border: InputBorder.none,
        focusedBorder: InputBorder.none,
        enabledBorder: InputBorder.none,
        errorBorder: InputBorder.none,
        disabledBorder: InputBorder.none,
        contentPadding:
            EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15)
      ),
      onChanged: (s) => onTxtChange(),
      keyboardType: only_numbers ? TextInputType.numberWithOptions(decimal: true) : null
    );

    if(boxed_in){
      return Boxes.build_soft_container(h, w, bg_color, text);
    } 
    return text;
  }
  static Widget long_text_entry(TextEditingController _c, {String hint = "", bool only_numbers = false, Color colour = Colors.black, double font_size = 22, FontWeight weight = FontWeight.w300, Function onTxtChange = TextEntry.TRASH, bool boxed_in: true, double h = 70, double w = 400, Color bg_color = const Color.fromARGB(255, 250, 250, 250)}){
    Widget text =  TextField(
      maxLines: null,
      keyboardType: TextInputType.multiline,
      controller: _c,
      style: TextStyle(color: colour, fontSize: font_size, fontWeight: weight),
      decoration: InputDecoration(
        labelText: hint,
        labelStyle: TextStyle(fontSize: font_size),
        border: InputBorder.none,
        focusedBorder: InputBorder.none,
        enabledBorder: InputBorder.none,
        errorBorder: InputBorder.none,
        disabledBorder: InputBorder.none,
        contentPadding:
            EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15)
      ),
      onChanged: (s) => onTxtChange(),
    );

    if(boxed_in){
      return Boxes.build_soft_container(h, w, bg_color, text);
    } 
    return text;
  }

}


class ColorOption {
  static Color bg = Color.fromARGB(255, 250, 250, 250);
  double size;
  double radius;
  Color color;
  Boolean active = new Boolean(false);
  CreateCarProfile_State stateful_pg;

  ColorOption(this.stateful_pg, this.size, this.radius, this.color, this.active);

  Widget build(){
    return GestureDetector(
      onTap: () => this.stateful_pg.set_active_color(this),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Stack(children: [
          CircleAvatar(
            backgroundColor: this.color,
            radius: this.size
          ),
          AnimatedContainer(
            duration: Duration(milliseconds: 500),
            child: CircleAvatar(
              backgroundColor: ColorOption.bg,
              radius: (this.active.get_set_state()) ? this.radius : 0
            ),
          )
        ],),
      ),
    );
  }
}

class ButtonsWidgets {
  static Widget rounded_button(double h, double w,  Function on_tap, dynamic args, { String txt: "", TextStyle style: const TextStyle(fontSize: 12), Color bg_colour = const Color.fromARGB(255, 240, 240, 240), }) {
    return GestureDetector(onTap: () => on_tap(args),
      child: Container(
        decoration: BoxDecoration(color: bg_colour, 
          borderRadius: new BorderRadius.all(const Radius.circular(50.0)),
          boxShadow: [
            BoxShadow(color: Colors.grey.withOpacity(0.4), spreadRadius: 0.3, blurRadius: 2, offset: Offset(2.5,3))
          ]
        ),
        height: h, width: w,
        child: Center(child: Text(txt, style: style))
      )
    );
  }
}

class DateSelector{
  
  static Function update_time(dynamic args){
      Date date_obj = args[2];
      dynamic page = args[1];
      DatePicker.showDatePicker(args[0],
            showTitleActions: true,
            minTime: DateTime(2018, 3, 5),
            maxTime: DateTime.now(), onChanged: (date) {
        }, onConfirm: (date) {
          page.setState(() { 
            date_obj.update_value(date); 
          });
          print("." + date.toString());
        }, currentTime: DateTime.now(), locale: LocaleType.en);

  }

  static Widget build_date_selector(context, dynamic pg, Date dateObj, double h, double w, {TextStyle style_ = const TextStyle(fontSize: 22), Color clr = Colors.amber}){

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ButtonsWidgets.rounded_button(h, w, DateSelector.update_time, [context, pg, dateObj], txt: dateObj.toString(), style: style_, bg_colour : clr),
    );
  }
  
}

class Boxes {
  static Widget build_soft_container(double h, double w, Color colour, Widget c){

    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: Container(
        height: h, width: w,
        decoration: BoxDecoration(
          color: colour,
          borderRadius: BorderRadius.all(const Radius.circular(8)),
          boxShadow: [
            BoxShadow(color: Colors.grey.withOpacity(0.5), spreadRadius: 0.3, blurRadius: 2, offset: Offset(2.5,3))
          ]
        ),
        child: c
      ),
    );
  }
  static Widget build_soft_container_animated(double h, double w, Color colour, Widget c){

    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        height: h, width: w,
        decoration: BoxDecoration(
          color: colour,
          borderRadius: BorderRadius.all(const Radius.circular(8)),
          boxShadow: [
            BoxShadow(color: Colors.grey.withOpacity(0.5), spreadRadius: 0.3, blurRadius: 2, offset: Offset(2.5,3))
          ]
        ),
        child: c
      ),
    );
  }
}