
import 'package:car_milage/BasicElements.dart';
import 'package:car_milage/page_GasFillUp.dart';
import 'package:car_milage/page_NewCarProfile.dart';
import 'package:car_milage/widget_library.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:bezier_chart/bezier_chart.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'CarProfile.dart';
import 'main.dart';

class CarProfileWidgetWrapper{
  static double height_opened = 980;
  static double height_closed = 100;

  static List<String> variables = [
    'Gallons', 'Milage', 'Gas Price', 'MPG'
  ];
  int current_preview = 0;
  Function get_graph_preview_type(int i){
    if(this.pg == null){
      print('Bad Stateful Homepage');
    }
    this.pg.setState((){
      this.preview_bools[this.current_preview].get_set_state(state:false);
      this.current_preview = i;
      this.preview_bools[this.current_preview].get_set_state(state:true);
    });
  }
  List<Boolean> preview_bools = [
    new Boolean(true),
    new Boolean(false),
    new Boolean(false),
    new Boolean(false)
  ];


  double page_width;
  MyHomePageState pg;
  Widget gas_record_setstate;
  Boolean state = Boolean(false);
  DateTime selected_date = null;
  CarProfile profile;
  CarProfileWidgetWrapper(this.profile){
    this.state = new Boolean(false);
    this.gas_record_setstate = build_day_record(DateTime.now(), 1, 5);
  }

  /*
    Builds Widget to Display Car Profile Records 
    ------        NAME      ------
    ----- GAS RECORDS GRAPHS -----
    ---   MAINTANCE RECORDS    --- 
  */  gi
  Widget build_profile_preview(double w){
    Widget child = Padding(padding: const EdgeInsets.all(8), child:Align(alignment: Alignment.centerLeft, child: Text(this.profile.getNickName() + "  " + this.profile.get_current_millage_str(), style: TextStyle(fontSize: 33, fontWeight:  FontWeight.w200, color: Colors.white))));
    Widget sliding = Slidable(actionPane: SlidableDrawerActionPane(),
      child: GestureDetector(
        onTap: () => this.pg.setState((){ 
              this.state.get_set_state(state:true);
        }),
        child: Boxes.build_soft_container(CarProfileWidgetWrapper.height_closed, this.page_width, Colors.amber, child),),
        actions: <Widget>[
        IconSlideAction(
          caption: 'Quick Fuel Up',
          //color: Colors.greenAccent,
          icon: Icons.local_gas_station,
          onTap: () => this.pg.open_fuel_up_page(this.profile),
        ),
      ]
    );
    return sliding;
  }
  Widget build_profile_expanded(double w){
    return Container(height: CarProfileWidgetWrapper.height_opened, width: double.infinity,
        child: Column(
          children: [
            GestureDetector(
              onTap: () => this.pg.setState((){ 
                    this.state.get_set_state(state:false);
              }),
              child: 
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 32),
                    child: Container(
                      width: w,
                      child: Align(
                        alignment: Alignment.center,
                        child: Row(
                          children: [
                            Text(this.profile.getNickName() + " - " + this.profile.getYearStr() + " " + this.profile.get_current_millage_str(),
                              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w300, color: Colors.black54)
                            ),
                          ]
                        ),
                      ),
                    )
                  )),
          Wrap(alignment: WrapAlignment.spaceEvenly, spacing: 25.0,
            children: [
              ButtonsWidgets.rounded_button(25, 75, this.get_graph_preview_type, 0, txt: CarProfileWidgetWrapper.variables[0], bg_colour: (preview_bools[0].get_set_state() ? Colors.amber : const Color.fromARGB(255, 240, 240, 240))),
              ButtonsWidgets.rounded_button(25, 75, this.get_graph_preview_type, 1, txt: CarProfileWidgetWrapper.variables[1], bg_colour: (preview_bools[1].get_set_state() ? Colors.amber : const Color.fromARGB(255, 240, 240, 240))),
              ButtonsWidgets.rounded_button(25, 75, this.get_graph_preview_type, 2, txt: CarProfileWidgetWrapper.variables[2], bg_colour: (preview_bools[2].get_set_state() ? Colors.amber : const Color.fromARGB(255, 240, 240, 240))),
              ButtonsWidgets.rounded_button(25, 75, this.get_graph_preview_type, 3, txt: CarProfileWidgetWrapper.variables[3], bg_colour: (preview_bools[3].get_set_state() ? Colors.amber : const Color.fromARGB(255, 240, 240, 240))),

            ],
          ),
          Container(height: 400, child: this.build_gas_records_chart(w)),
          this.build_day_record(this.selected_date, 200, w),
          this.build_all_records_section(w, 280),
        ],
        ));
  }
  Widget build_profile_element(MyHomePageState pg, double w){
    this.pg = pg;
    this.page_width = w;
    return AnimatedContainer(
      duration: Duration(milliseconds: 100),
      height: this.state.get_set_state() ? CarProfileWidgetWrapper.height_opened : CarProfileWidgetWrapper.height_closed,
      width: this.page_width,
      child:  this.state.get_set_state() ? this.build_profile_expanded(page_width) : this.build_profile_preview(page_width)
    );
  }

  Function new_record(dynamic arg){
    this.pg.open_new_record_page(this.profile);
  }

  

  /*
  Builds Widget Displaying Gas Record at specified input Day
  Inputs: 
      d {DateTime} : Date of record to look up
      h {double} : height
      w {double} : width 
  Next Steps: Work with Multiple Records in Specified Day 
  */
  Widget build_day_record(DateTime d, double h, double w){
    if(d == null){
      return Container(
        height: 0, width: w,
      );
    }
    List<GasRecord> retrieved = this.profile.get_records_at_date(Date.build_from_DateTime(d));
    if(retrieved == null){
      return Container(
        height: 0, width: w,
      );
    }
    GasRecord r = retrieved.last; ///currently only get last record from day 
    Widget obj = Container(
      height: h, width: w,
      child: Wrap(
        alignment: WrapAlignment.spaceAround,
        spacing: 5,
        children: [
          Boxes.build_soft_container(h / 3.5, w / 1.1, Colors.amber, Center(child:Text(r.get_date().toString(), style:TextStyle(fontWeight: FontWeight.w200, color: Colors.white, fontSize: 32),))),
          Boxes.build_soft_container(h / 3.2, w / 2.1, Colors.amber, Center(child:Text(r.get_total_str(), style:TextStyle(fontWeight: FontWeight.w200, color: Colors.white, fontSize: 32),))),
          Boxes.build_soft_container(h / 3.2, w / 2.1, Colors.amber, Center(child:Text(r.get_mpg().toStringAsFixed(2) + " mpg", style:TextStyle(fontWeight: FontWeight.w200, color: Colors.white, fontSize: 28),))),
          Boxes.build_soft_container(h / 3.4, w / 3.4, Colors.amber, Center(child:Text(r.get_milage_delta().toString() + ' miles', style:TextStyle(fontWeight: FontWeight.w200, color: Colors.white, fontSize: 22)))),
          Boxes.build_soft_container(h / 3.4, w / 3.4, Colors.amber, Center(child:Text(r.get_gallons().toStringAsFixed(2) + ' gal', style:TextStyle(fontWeight: FontWeight.w200, color: Colors.white, fontSize: 22)))),
          Boxes.build_soft_container(h / 3.4, w / 3.4, Colors.amber, Center(child:Text(r.get_price_per_gallon().toString() + ' /gal', style:TextStyle(fontWeight: FontWeight.w200, color: Colors.white, fontSize: 22)))),

      ],)
    );
    return obj;
  }

  void build_chart_data(List<DataPoint<DateTime>> milage, List<DataPoint<DateTime>> price, List<DataPoint<DateTime>> gallons, List<DataPoint<DateTime>> mpg, double scale){ 
    bool skip_first = false;
    this.profile.get_gas_records().forEach((key, value) {
      value.toList().forEach((element) {
        if(skip_first){
          DateTime date = element.get_date().to_datetime();
          if(element.get_milage_delta() != null)
            milage.add(DataPoint<DateTime>(xAxis: date, value: element.get_milage_delta() * scale));
          if(element.get_mpg() != null) {
            mpg.add(DataPoint<DateTime>(xAxis: date, value: element.get_mpg() * scale));
          }
          price.add(DataPoint<DateTime>(xAxis: date, value: element.get_price_per_gallon().toDouble() * scale));
          gallons.add(DataPoint<DateTime>(xAxis: date, value: element.get_gallons() * scale));
          
        } else {
          skip_first = true;
        }
      });
    });
  }

  /*
    Builds Beizer Graphs for the Car's Gas Record 
  */
  Widget build_gas_records_chart(double w){
    List<DataPoint<DateTime>> gallon_data = new List();
    List<DataPoint<DateTime>> milage_data = new List();
    List<DataPoint<DateTime>> price_per_gallon_data = new List();
    List<DataPoint<DateTime>> mpg_data = new List();

    this.build_chart_data(milage_data, price_per_gallon_data, gallon_data, mpg_data, 1);
    //Check if there are engough records to be built 
    if(gallon_data.length == 0 || milage_data.length == 0 || price_per_gallon_data.length == 0 || mpg_data.length == 0){
      return Container(child: Center(child: Text('No Gas Records Yet'),),);
    }

    DateTime current_date = this.profile.min_date;

    List<BezierLine> lines = [ //build data for each possible graph 
      BezierLine(label: " Gallons", data: gallon_data, lineColor: Colors.amber),
      BezierLine(label: " Miles", data: milage_data, lineColor: Colors.amber),
      BezierLine(label: " USD", data: price_per_gallon_data, lineColor: Colors.amber),
      BezierLine(label: " MPG", data: mpg_data, lineColor: Colors.amber),
    ];

    BezierLine current_line = lines[this.current_preview];

    return BezierChart(
      key: Key("chart"),
      bezierChartScale: BezierChartScale.WEEKLY,
      fromDate: this.profile.min_date,
      toDate: this.profile.max_date,
      
      onIndicatorVisible: (val) {
        print("Indicator Visible :$val");
        if(val == false){
          this.pg.setState(() {
            this.selected_date = null;
          });
        }
      },
      onDateTimeSelected: (datetime) {
        print("selected datetime: $datetime");
        WidgetsBinding.instance.addPostFrameCallback((_){
          this.pg.setState(() {
            this.selected_date = datetime;
          });
        });
      },
      onScaleChanged: (scale) {
        print("Scale: $scale");
      },
      selectedDate: current_date,
      series: [
        current_line
      ],
      config: BezierChartConfig(
          displayDataPointWhenNoValue: false,
          verticalIndicatorStrokeWidth: 1.0,
          pinchZoom: true,
          startYAxisFromNonZeroValue: false,
          displayLinesXAxis: true,
          displayYAxis: true,
          stepsYAxis: (this.current_preview == 0) ? 10 :  (this.current_preview == 1) ? 1000 : 1, 
          physics: ClampingScrollPhysics(),
          verticalIndicatorColor: Colors.black26,
          showVerticalIndicator: false,
          verticalIndicatorFixedPosition: false,
          yAxisTextStyle: TextStyle(color: Colors.black87, fontSize: 12, fontWeight: FontWeight.w100),
          xAxisTextStyle: TextStyle(color: Colors.black87, fontSize: 12, fontWeight: FontWeight.w100),
        ),
    );
  }



  /*
    Builds Space for any Maintance Records for the Car 
  */
  List<RecordWidgetWrapper> general_records_widgets = new List();
  Widget build_all_records_section(double w, double h){
    //add test records
    Random r = new Random();
    for(int i = 0; i < 3; i++){
      //this.profile.addGeneralRecord(Record(Date(2020, r.nextInt(10) + 1, r.nextInt(15) + 1), null, r.nextDouble() * 50));
    }


    List<Widget> all_records = new List();
    all_records.add(Padding(
      padding: const EdgeInsets.all(8.0),
      child: ButtonsWidgets.rounded_button(50, 20, this.new_record, null, txt: "New Record", bg_colour: Colors.amber, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w300)),
    ));
    if(this.general_records_widgets.length != this.profile.sum_of_general_records){
      this.general_records_widgets = new List();
      this.profile.get_general_records().forEach((key, value) {
        value.forEach((element) {
          general_records_widgets.add(RecordWidgetWrapper(element, this.pg));
        });
      });
    }
    this.general_records_widgets.forEach((element) {
      all_records.add(element.build(50, w));
    });
    
    
    
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(height:  h, width: w,
        child: ListView(children: all_records,)
      ),
    );
  }

}

/*
  Responsible for Managing Changes to the Maintance Records and Building their Widgets 
*/
class RecordWidgetWrapper {
  Record _record;
  Boolean state;
  MyHomePageState pg;
  List<SubRecordHomePageWrapper> subrecords_wrapper = new List();

  RecordWidgetWrapper(this._record, this.pg, {Boolean start_state: null}){
    if(start_state == null){ this.state = Boolean(false); }
    else { this.state = start_state; }
  }

  Widget _collapsed(double h){
    return Align(
      alignment: Alignment.centerLeft,
      child: Wrap(alignment: WrapAlignment.start,
        children: [
          Text(this._record.get_date().toString(), style: TextStyle(color: Colors.black26, fontSize:  22, fontWeight: FontWeight.w300,))
        ],),
    );
  }

  Widget build_top_area(){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Stack(
          children: [
            Align(alignment: Alignment.topLeft, child: Text(this._record.get_date().toString(), style: TextStyle(color: (this.state.get_set_state() ? Colors.amber : Colors.black26), fontSize:  22, fontWeight: FontWeight.w300,))),
            Align(alignment: Alignment.topRight, child: (this.state.get_set_state() ? Text(this._record.get_total_str(), style: TextStyle(color: Colors.black26, fontSize:  22, fontWeight: FontWeight.w300,)) : Container()))
          ],
        ),
    );
  }
  Widget build_sub_record_area(double h, double w){
    if(this.state.get_set_state() == false) { return Container(); }
    this.subrecords_wrapper = this._record.build_subwidgets(h);
    List<Widget> summaries = new List();
    this.subrecords_wrapper.forEach((element) {
      summaries.add(element.build(h, w));
    });
    return Container(height: h, child: CarouselSlider(
            options: CarouselOptions(
              height: h,
              viewportFraction: 1.0,
              enlargeCenterPage: false,
              enableInfiniteScroll: false,
            ),
            items: summaries)
    );
  }
  Widget build(double h, double w){

    Widget child = Column(children: [
        this.build_top_area(),
        this.build_sub_record_area(h * 3, w)
    ],);

    return GestureDetector(
      onTap: () => this.pg.setState((){print(this.state.toggle()); }),
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Boxes.build_soft_container_animated((this.state.get_set_state() ? h * 4 : h), w, (this.state.get_set_state() ? Colors.white : Colors.grey[100]), child)
      ),
    );
  }

}
