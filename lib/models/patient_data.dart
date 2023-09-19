class UserModel {
  String? uid;
  String? name;
  String? address;
  String? email;
  String? age;
  String? dob;
  String? password;
  String? gender;
  String? last_name;
  String? phone;
  String? status;
  var profileImage;

  UserModel({
    this.uid,
    this.name,
    this.address,
    this.email,
    this.age,
    this.dob,
    this.password,
    this.gender,
    this.last_name,
    this.phone,
    this.status,
    this.profileImage,
  });

//reciving data from server
  factory UserModel.fromMap(map) {
    return UserModel(
      uid: map['uid'],
      name: map['name'],
      address: map['address'],
      email: map['email'],
      age: map['age'],
      dob: map['dob'],
      password: map['password'],
      gender: map['gender'],
      last_name: map['last name'],
      phone: map['phone'],
      status: map['status'],
      profileImage: map['profileImage'],
    );
  }

//sending data to our server
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'address': address,
      'email': email,
      'age': age,
      'dob': dob,
      'gender': gender,
      'password': password,
      'last name': last_name,
      'phone': phone,
      'status': status,
      'profileImage': profileImage,
    };
  }
}
