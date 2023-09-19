class Doctor {
  String? firstName;
  String? lastName;
  String? image;
  String? type;
  double? rating;

  Doctor({
    this.firstName,
    this.lastName,
    this.image,
    this.type,
    this.rating,
  });
}

class DoctorModel {
  String? uid;
  String? name;
  String? address;
  String? email;
  String? experience;
  String? specialist;
  String? password;
  String? description;
  String? phone;
  String? rating;
  var available;
  var valid;
  var profileImage;

  DoctorModel({
    this.uid,
    this.name,
    this.address,
    this.email,
    this.experience,
    this.specialist,
    this.password,
    this.description,
    this.phone,
    this.rating,
    this.available,
    this.valid,
    this.profileImage,
  });

//reciving data from server
  factory DoctorModel.fromMap(map) {
    return DoctorModel(
      uid: map['uid'],
      name: map['name'],
      address: map['address'],
      email: map['email'],
      experience: map['experience'],
      specialist: map['specialist'],
      password: map['password'],
      description: map['description'],
      phone: map['phone'],
      profileImage: map['profileImage'],
      rating: map['rating'],
      available: map['available'],
      valid: map['valid'],
    );
  }

//sending data to our server
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'address': address,
      'email': email,
      'experience': experience,
      'specialist': specialist,
      'password': password,
      'description': description,
      'phone': phone,
      'profileImage': profileImage,
      'rating': rating,
      'available': available,
      'valid':valid,
    };
  }
}
