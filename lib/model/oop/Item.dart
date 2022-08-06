class Item {
  String? itemId;
  String? name;
  String? info;
  String? price;
  String? weight;
  String? quant;
  String? count;

  Item({this.itemId, this.name, this.info, this.price, this.weight, this.quant, this.count});

  Item.fromJson(Map<String, dynamic> json) {
    itemId = json['item_id'];
    name = json['name'];
    info = json['info'];
    price = json['price'];
    weight = json['weight'];
    count = json['count'];
    quant = json['quant'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['item_id'] = this.itemId;
    data['name'] = this.name;
    data['info'] = this.info;
    data['price'] = this.price;
    data['weight'] = this.weight;
    data['quant'] = this.quant;
    return data;
  }
}