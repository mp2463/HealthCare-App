class User {
  var userId;
  var gender;

  User({this.userId, this.gender});

  static List<User> getUsers() {
    return <User>[
      User(userId: 1, gender: "Male"),
      User(userId: 1, gender: "Female")
    ];
  }
}
