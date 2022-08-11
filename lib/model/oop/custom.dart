class Customer {
  String? id;
  String? name;
  String? phone;
  String? password;
  String? createTime;

  Customer({this.id, this.name, this.phone, this.password, this.createTime});

  Customer.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    phone = json['phone'];
    password = json['password'];
    createTime = json['createTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['phone'] = this.phone;
    data['password'] = this.password;
    data['createTime'] = this.createTime;
    return data;
  }
}

