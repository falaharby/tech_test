class Address {
  final int id, zipCode;
  final String address, city, state;

  Address(this.id, this.address, this.city, this.state, this.zipCode);

  Address.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        address = json['address'],
        city = json['city'],
        state = json['state'],
        zipCode = json['zip_code'];
}

class AddressResponse {
  final List<Address> datas;
  final String error;

  AddressResponse(this.datas, this.error);

  AddressResponse.fromJson(Map<String, dynamic> json)
      : datas =
            (json["results"] as List).map((i) => Address.fromJson(i)).toList(),
        error = "";

  AddressResponse.withError(String errorValue)
      : datas = [],
        error = errorValue;
}
