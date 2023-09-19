class RatingModel {
  String? approve;
  String? date;
  String? did;
  String? doctor_name;
  String? name;
  String? phone;
  String? pid;
  String? rating;
  String? time;
  String? visited;

  RatingModel({
    this.visited,
    this.name,
    this.approve,
    this.date,
    this.did,
    this.doctor_name,
    this.pid,
    this.rating,
    this.time,
    this.phone,
  });

//reciving data from server
  factory RatingModel.fromMap(map) {
    return RatingModel(
      visited: map['uid'],
      name: map['name'],
      approve: map['approve'],
      date: map['date'],
      did: map['did'],
      doctor_name: map['doctor_name'],
      pid: map['pid'],
      rating: map['rating'],
      time: map['time'],
      phone: map['phone'],
    );
  }

//sending data to our server
  Map<String, dynamic> toMap() {
    return {
      'visited': visited,
      'name': name,
      'approve': approve,
      'date': date,
      'did': did,
      'doctor_name': doctor_name,
      'pid': pid,
      'rating': rating,
      'time': time,
      'phone': phone,
    };
  }
}
