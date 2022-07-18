class Employee {
  String? id;
  String? name;
  String? password;
  String? phone;

  Employee({this.id, this.name, this.password, this.phone});

  Employee.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    password = json['password'];
    phone = json['phone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['password'] = this.password;
    data['phone'] = this.phone;
    return data;
  }
}