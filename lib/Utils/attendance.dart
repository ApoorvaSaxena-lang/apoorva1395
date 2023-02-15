class Attendance {
  String name;
  String checkIn;
  String checkOut;
  String totalDuration;
  String date;

  Attendance(
      this.name, this.checkIn, this.checkOut, this.totalDuration, this.date);

  toJson() => {
        'name': name,
        'check_in': checkIn,
        'check_out': checkOut,
        'total_duration': totalDuration,
        'date': date
      };
}
