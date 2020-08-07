

import 'package:car_milage/CarProfile.dart';
import 'package:car_milage/widget_library.dart';
import 'package:flutter/material.dart';

import 'BasicElements.dart';
import 'main.dart';

class CarProfleManager {
  static CarProfleManager manager;

  static CarProfleManager get_manager() {
    if(CarProfleManager.manager == null){ CarProfleManager.manager = new CarProfleManager(); }
    return CarProfleManager.manager;
  }
  List<CarProfile> profiles;
  CarProfleManager(){
    this.profiles = new List();
    //load saved cars 
  }

  Widget build_list(double w, MyHomePageState pg) {
    if(this.profiles.length == 0) {
      return Center(child: Text("No Profiles Yet."),);
    }
    List<Widget> items = new List();
    int i = 0;
    this.profiles.forEach((element) {
      items.add(Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: element.getWidgetWrapper().build_profile_element(pg, w),
      ));
      i ++;
    });
    //return CarProfileWidgets.build_profile_expanded(this.profiles[0], new Boolean(true));
    return ListView(children: items,);
  }



  void add_profile(CarProfile p){
    this.profiles.add(p);
  }


} 