class Identity {
  final String userName;
  final String password;

  Identity(this.userName, this.password);

  Identity.fromJson(Map<String, dynamic> json)
      : userName = json['user_name'],
        password = json['password'];

  Map<String, dynamic> toJson() => {
        "user_name": userName,
        "password": password,
      };
}
