class UserInfo {
  String name;
  String email;
  String phone;
  String password;
  String image;
  String dob;

  UserInfo(
      this.name, this.email, this.phone, this.password, this.image, this.dob);

  toJson() => {
        'name': name,
        'email': email,
        'phone': phone,
        'password': password,
        'image': image,
        'dob': dob
      };
}
