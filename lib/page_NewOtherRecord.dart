import 'package:car_milage/CarProfile.dart';
import 'package:car_milage/page_GasFillUp.dart';
import 'package:car_milage/widget_library.dart';
import 'package:flutter/material.dart';

import 'BasicElements.dart';
import 'main.dart';



class OtherRecordPage extends StatefulWidget{

  MyHomePageState pg;
  CarProfile lcl_profile;
  OtherRecordPage(this.pg, this.lcl_profile);

  @override
  OtherRecordPage_State createState() => OtherRecordPage_State(this);
}

class OtherRecordPage_State extends State<OtherRecordPage>{
  TextEditingController new_milage_c = new TextEditingController();
  TextEditingController final_price_c = new TextEditingController();
  double final_price = null;
  List<SubRecord_Wrapper> sub_records_wrapper_objs = new List();

  OtherRecordPage parent;
  Date lcl_date;

  OtherRecordPage_State(this.parent){
    this.lcl_date = Date.now();
  } 

  void updatePrice(){
    this.final_price = 0;
    this.sub_records_wrapper_objs.forEach((element) {
      double l = element.lcl_record.get_set_cost().toDouble();
      if(l != null)
        this.final_price += l;
    });
    this.setState(() { 
      this.final_price_c.text = this.final_price.toStringAsFixed(2);
    });
  }


  void sumbit_record(dynamic args){
    double current_milage = GasFuelUpPage_State.get_txt_conversion(this.new_milage_c);
    double cost_total= GasFuelUpPage_State.get_txt_conversion(this.final_price_c);
    List<Sub_Record> sub_records = new List();
    this.sub_records_wrapper_objs.forEach((element) {
      sub_records.add(element.lcl_record);
    });

    Record lcl_Record = new Record(this.lcl_date, sub_records, cost_total, milage: current_milage.floor());
    this.parent.pg.setState(() {
      this.parent.lcl_profile.addGeneralRecord(lcl_Record);
    });
    this.close_page(context);
  }

  Future close_page(context) async {
    Navigator.pop(context, true);
  }
  Function new_sub_record(dynamic args){
      this.setState(() {
      this.sub_records_wrapper_objs.add(new SubRecord_Wrapper(this));
    });
  }
  Widget build_gradient(double h, double w, Alignment b, Alignment e){
    Color start = Color.fromARGB(0, 250, 250, 250);
    Color end = Color.fromARGB((this.sub_records_wrapper_objs.length == 0 ? 0 : 255), 250, 250, 250);
    return Container(height: h, width: w, 
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: b,
              end: e,
              colors: [start, end])),);
  }
  Widget build_sub_record_area(double h, double w){
    Widget new_button = Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 50),
      child: ButtonsWidgets.rounded_button(50, w * 0.5, this.new_sub_record, null, txt: "New Entry", style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w200), bg_colour: Colors.amber));
    List<Widget> entries = new List();
    double record_range = (64) + (this.sub_records_wrapper_objs.length * 80.0);
    double lcl_height = (record_range > h) ? h : (record_range < 264 ? 264 : record_range);
    entries.add(new_button);
    this.sub_records_wrapper_objs.forEach((element) {
      entries.add(element.build(w));
     });
    
    Widget _list_view_area = ListView(children: entries);

    return Stack(
      children: [
        AnimatedContainer(duration: Duration(milliseconds: 500), height: lcl_height, width: w, child: 
          Stack(children: [
            _list_view_area,
            (this.sub_records_wrapper_objs.length == 0 ? Container() : IgnorePointer(child: Align(alignment: Alignment.bottomCenter, child: this.build_gradient(30, w, Alignment.topCenter, Alignment.bottomCenter)))),
            (this.sub_records_wrapper_objs.length == 0 ? Container() : IgnorePointer(child: Align(alignment: Alignment.topCenter, child: this.build_gradient(30, w, Alignment.bottomCenter, Alignment.topCenter))))
            ]),
        )
      ]);
  }

  @override
  Widget build(BuildContext context) {
    double screen_width =  MediaQuery.of(context).size.width;
    double screen_height=  MediaQuery.of(context).size.height;

    Widget page = Column(children: [
      Center(child: DateSelector.build_date_selector(context, this, this.lcl_date, 50, 300)),
      Padding(padding:  const EdgeInsets.symmetric(vertical: 5, horizontal: 15), child: TextEntry.simple_text_entry(this.new_milage_c, hint: "Current Milage")),
      this.build_sub_record_area(screen_height / 2.5, screen_width),
      Padding(padding:  const EdgeInsets.symmetric(vertical: 15, horizontal: 15), child: TextEntry.simple_text_entry(this.final_price_c, hint: "Total Price")),

    ],);

    // TODO: implement build
    return Scaffold(
      appBar: AppBar(title: Text(this.parent.lcl_profile.getNickName()),),
      body: new GestureDetector(
        onTap: () { FocusScope.of(context).requestFocus(new FocusNode()); },
        child: Stack(children: [ 
          page, 
          Align(alignment: Alignment.bottomCenter, child: Padding(
            padding: const EdgeInsets.only(bottom: 32.0),
            child: ButtonsWidgets.rounded_button(50, 170, this.sumbit_record, context, bg_colour: Colors.amber, txt: 'Submit', style: const TextStyle(fontSize: 22, color: Colors.white, fontWeight: FontWeight.w200)),
          ))
        ])
      )
    );
  }
  


}



class SubRecord_Wrapper {
  double height_closed = 70;
  double height_opened = 200;
  Boolean _state = new Boolean(false);
  TextEditingController description_c = new TextEditingController();
  TextEditingController price_c = new TextEditingController();
  TextEditingController notes_c = new TextEditingController();

  Sub_Record lcl_record;
  OtherRecordPage_State pg;
  SubRecord_Wrapper(this.pg){
    this.lcl_record = new Sub_Record("N/A");
  }

  Function update_cost(){
    this.lcl_record.get_set_cost(value: GasFuelUpPage_State.get_txt_conversion(this.price_c));
    this.pg.updatePrice();
  }
  Function update_summary(){
    this.lcl_record.get_set_summary(value: this.description_c.text);
  }
  Function update_notes(){
    this.lcl_record.get_set_notes(value: this.notes_c.text);
  }
  Widget build(double w) {
    Widget child = Column(
      children: [
        Stack(
          children: [
            Align(alignment: Alignment.topLeft, child: Container(width: w * 1.5 / 3, child: TextEntry.simple_text_entry(this.description_c, hint: "Description", font_size: 17, boxed_in: false, onTxtChange: this.update_summary))),
            Align(alignment: Alignment.topRight, child: Container(width: w / 3, child: TextEntry.simple_text_entry(this.price_c, hint: "Price", font_size: 17, boxed_in: false, onTxtChange: this.update_cost))),
          ],
        ),
      (this._state.get_set_state() ? 
          Center(child: Container(height: (this.height_opened - this.height_closed), width: w, child: TextEntry.long_text_entry(this.notes_c, hint: "Notes", font_size: 17, onTxtChange: this.update_notes)))
          :
          Container())
      ]
    );
    return Dismissible(
      key: Key(this.lcl_record.hashCode.toString()),
      onDismissed: (direction) => this.pg.setState(() {
        this.pg.sub_records_wrapper_objs.remove(this);
      }),
      child: GestureDetector(
        onTap: ()=> pg.setState(() { this._state.toggle();}),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Boxes.build_soft_container_animated((this._state.get_set_state() ? this.height_opened : this.height_closed), w, Colors.grey[100], Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
            child: child,
          )),
        ),
      ),
    );
  }
}