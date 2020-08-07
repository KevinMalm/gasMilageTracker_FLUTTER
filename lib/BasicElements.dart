

class Boolean {

  bool _state = true;
  int temp_data = null;
  Boolean(this._state);
  bool toggle() {
    if(this._state){ this._state = false; }
    else { this._state = true; }
    return this._state;
  }
  bool get_set_state({bool state = null}){
    if(state != null) { this._state = state; }
    return this._state;
  }
  int get_set_temp({int s = null}){
    if(s != null) { this.temp_data = s; }
    return this.temp_data;
  }

}

class Date {

  int year, month, day;
  int hour, minute;

  Date(this.year, this.month, this.day){
    this.minute = 0;
    this.hour = 0;
  }
  static Date build_from_DateTime(DateTime d) {
    Date new_date = new Date(d.year, d.month, d.day);
    new_date.hour = d.hour;
    new_date.minute = d.minute;
    return new_date;
  }
  
  static Date now(){
    return Date.build_from_DateTime(DateTime.now());
  }


  void update_value(DateTime d){
    this.year = d.year;
    this.month = d.month;
    this.day = d.day;
    this.hour = d.hour;
    this.minute = d.minute;
  }
  DateTime to_datetime(){
    return new DateTime(year = this.year, month = this.month, day = this.day, hour = this.hour, minute = this.hour);
  }
  @override
  String toString(){
    String div = "/";
    return this.month.toString() + div + this.day.toString() + div + this.year.toString();
  }
}


class USD {
  static USD ZERO = USD(0,0);
  int dollars;
  int cents;
  USD(this.dollars, this.cents);

  static USD fromDouble(double v){
    int dollars = v.floor();
    int cents = ((v - dollars) * 100).round();
    return USD(dollars, cents);
  }

  double toDouble(){
    return (this.dollars + (this.cents / 100));
  }
  @override
  String toString(){
    return r"$" + this.dollars.toString() + "." + this.cents.toString();
  }
  @override
  int compareTo(USD obj){
    if(obj.cents == this.cents && obj.dollars == this.dollars){
      return 0;
    }
    if(this.dollars > obj.dollars)
      return 1;
    if(this.dollars < obj.dollars)
      return -1;
    if(this.cents > obj.cents)
      return 1;
    if(this.cents < obj.cents)
      return -1; 
    return -2;
  }
}