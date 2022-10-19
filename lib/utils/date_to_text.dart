String dateToTextConvertor(DateTime date) {
  int day = date.day;
  int month = date.month;
  int year = date.year;

  return "$day-$month-$year";
}
