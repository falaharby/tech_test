class Emails {
  final int id;
  final String emails, phone;

  Emails(this.id, this.emails, this.phone);

  Emails.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        emails = json['email'],
        phone = json['phone'];
}

class EmailsResponse {
  final List<Emails> datas;
  final String error;

  EmailsResponse(this.datas, this.error);

  EmailsResponse.fromJson(Map<String, dynamic> json)
      : datas =
            (json["results"] as List).map((i) => Emails.fromJson(i)).toList(),
        error = "";

  EmailsResponse.withError(String errorValue)
      : datas = [],
        error = errorValue;
}
