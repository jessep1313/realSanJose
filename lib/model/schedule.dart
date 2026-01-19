enum Status {
  progress,completed,accepted,unconfirmed
}
class Schedule {
  String image;
  String callType;
  String name;
  String time;
  Status status;

  Schedule(this.image, this.callType, this.name, this.time, this.status);
}
