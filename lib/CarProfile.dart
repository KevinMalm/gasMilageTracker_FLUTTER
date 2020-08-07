import 'package:car_milage/widget_library.dart';
import 'package:flutter/material.dart';

import 'BasicElements.dart';
import 'main_pageCarProfile.dart';

class CarProfile {
  static List<Color> colour_options = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Color.fromARGB(255, 230, 230, 230),
    Colors.grey,
    Colors.black
  ];
  static List<Map<String, String>> car_options = [
    {'key': "4 Door Sedan", 'img': "graphics/sedan.png"},
    {'key': "2 Door Sedan", 'img': "graphics/2_door.png"},
    {'key': "Truck", 'img': "graphics/Truck.png"},
    {'key': "Minivan", 'img': "graphics/Minivan.png"},
  ];

  //Car Variables
  String _nickname = "";
  int starting_milage = 0;
  int current_millage(){
    if(this.prev_record == null)
      return this.starting_milage;
    return this.prev_record.milage;
  }
  int year = 0;
  double initial_price = null;
  Map<String, String> car_type = CarProfile.car_options[0];
  Color car_colour = CarProfile.colour_options[0];
  CarProfileWidgetWrapper wrapper;
  CarProfileWidgetWrapper getWidgetWrapper() => this.wrapper;
  //Records
  Map<String, List<Record>> _general_record = new Map<String, List<Record>>();
  Map<String, List<GasRecord>> _gas_record = new Map<String, List<GasRecord>>();
  Map<String, List<GasRecord>> get_gas_records() => this._gas_record;
  Map<String, List<Record>> get_general_records() => this._general_record;

  //Graphic Variables
  DateTime min_date = new DateTime(2000);
  DateTime max_date = DateTime.now();
  int max_milage_delta = 0;
  USD max_price_per_gallon = USD.ZERO;
  double max_gallons = 0;
  GasRecord prev_record = null;
  GasRecord get_last_record() => this.prev_record;

  CarProfile(this._nickname, this.starting_milage, this.year, this.car_type,
      this.car_colour) {
    this._general_record = new Map<String, List<Record>>();
    this._gas_record = new Map<String, List<GasRecord>>();
    this.wrapper = new CarProfileWidgetWrapper(this);
    this.addGasRecord(GasRecord(Date.now(), 0, 0, 0, this.starting_milage, null, 0));
  }

  /* GETTER / SETTER */
  String getNickName() => this._nickname;
  String getYearStr() => this.year.toString();
  Color get_set_colour({Color colour = null}) {
    if (colour != null) {
      this.car_colour = colour;
    }
    return this.car_colour;
  }


  String get_current_millage_str() {
    String number = this.current_millage().toString();
    String txt = "";
    int cnter = 0;
    for (int i = number.length - 1; i >= 0; i--) {
      txt = number[i] + txt;
      cnter += 1;
      if (cnter >= 3 && i > 0) {
        cnter = 0;
        txt = ',' + txt;
      }
    }
    return txt + " miles";
  }

  double get_set_price({double value = null}) {
    if (value != null) {
      this.initial_price = value;
    }
    return this.initial_price;
  }

  int sum_of_general_records = 0;
  void addGeneralRecord(Record r) {
    if (this._general_record[r._date.toString()] == null)
      this._general_record[r._date.toString()] = new List();
    this._general_record[r._date.toString()].add(r);
    this.sum_of_general_records += 1;
  }

  void addGasRecord(GasRecord r) {
    if (this.prev_record == null) {
      this.min_date = r._date.to_datetime();
    }
    if(this._gas_record[r._date.toString()] == null){
      this._gas_record[r._date.toString()] = new List();
    }
    if(this.max_date.compareTo(r._date.to_datetime()) < 0){
      this.max_date = r._date.to_datetime();
    }
    if(this.min_date.compareTo(r._date.to_datetime()) > 0){
      this.min_date = r._date.to_datetime();
    }
    this._gas_record[r._date.toString()].add(r);
    this.prev_record = r;
  }

  List<GasRecord> get_records_at_date(Date d) {
    return this._gas_record[d.toString()];
  }
}

class LinkedList<T> {
  List<T> _list;
  LinkedList() {
    this._list = new List<T>();
  }
  void add(T item) {
    this._list.add(item);
  }

  List<T> toList() {
    return this._list;
  }
}

class Record {
  List<Sub_Record> _summary;
  USD _cost;
  Date _date;
  int milage;
  String get_total_str() => this._cost.toString();

  String get_description() {
    int cap = 6;
    String v = "";
    int i = 0;
    while (i < this._summary.length || v.length < cap) {
      v += this._summary[i]._summary + ", ";
      i += 1;
    }

    return v;
  }

  Record(this._date, this._summary, double cost, {this.milage = 0}){
    this._cost = USD.fromDouble(cost);
  }
  Date get_date() => this._date;

  List<SubRecordHomePageWrapper> build_subwidgets(double h) {
    return this._summary.map((e) => SubRecordHomePageWrapper(e)).toList();
  }
}

class Sub_Record {
  USD cost = USD.ZERO;
  String _summary;
  String _notes = "";
  Sub_Record(this._summary, {double cost = 0}){
    if(cost != 0){
      this.cost = USD.fromDouble(cost);
    }
  }

  USD get_set_cost({double value = null}) {
    if (value != null) this.cost = USD.fromDouble(value);
    return this.cost;
  }

  String get_set_summary({String value = null}) {
    if (value != null) this._summary = value;
    return this._summary;
  }

  String get_set_notes({String value = null}) {
    if (value != null) this._notes = value;
    return this._notes;
  }
}

class GasRecord extends Record {
  double _gallons, mpg;
  USD _ppg;
  GasRecord last_record = null;
  GasRecord(Date date, double cost, this._gallons, double price_per_gallon,int milage, this.last_record, this.mpg) : super(date, null, cost, milage: milage) {
    this._ppg = USD.fromDouble(price_per_gallon);
  }
  double get_gallons() => this._gallons;

  USD get_price_per_gallon() => this._ppg;

  int get_milage_delta() =>
      (this.last_record == null) ? null : this.milage - this.last_record.milage;
  double get_mpg() {
    if (this.mpg == null) {
      return 0;
    }
    return this.mpg;
  }
}

class SubRecordHomePageWrapper {
  Sub_Record lcl_record;
  TextEditingController summary_c = new TextEditingController();
  TextEditingController price_c = new TextEditingController();
  TextEditingController notes_c = new TextEditingController();
  SubRecordHomePageWrapper(this.lcl_record) {
    this.summary_c.text = lcl_record.get_set_summary();
    this.price_c.text = lcl_record.get_set_cost().toString();
    this.notes_c.text = lcl_record.get_set_notes();
  }

  Widget build(double h, double w) {
    return Container(
        height: h,
        width: w,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Align(alignment: Alignment.topLeft, child: Text(this.lcl_record.get_set_summary() + " - " + this.lcl_record.get_set_cost().toString(), style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.w400))),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 3.0),
              child: Container(height: 2, width: w, color: Colors.amber),
            ),
            TextEntry.simple_text_entry(this.notes_c, h: 20, w: w * 0.5, boxed_in: false, font_size: 18, colour: Colors.black54, hint: "Notes"),

          ]),
        ));
  }
}
/*
Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                        child: TextEntry.simple_text_entry(this.summary_c,
                            h: 40, w: w * 0.5, boxed_in: false))),
                Container(
                  width: w * 0.3,
                  child: Align(
                      alignment: Alignment.bottomCenter,
                      child: TextEntry.simple_text_entry(this.price_c,
                          h: 40, w: w * 0.3, boxed_in: false)),
                )
*/