class Candidate {
  final int id;
  final String name, gender, photo;
  final DateTime birthday, expired;

  Candidate(
      this.id, this.name, this.gender, this.photo, this.birthday, this.expired);

  Candidate.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        name = json["name"],
        gender = json['gender'],
        photo = json['photo'],
        birthday = DateTime.fromMicrosecondsSinceEpoch(json['birthday'] * 1000),
        expired = DateTime.fromMillisecondsSinceEpoch(json['expired'] * 1000);
}

class CandidateResponse {
  final List<Candidate> datas;
  final String error;

  CandidateResponse(this.datas, this.error);

  CandidateResponse.fromJson(Map<String, dynamic> json)
      : datas = (json["results"] as List)
            .map((i) => Candidate.fromJson(i))
            .toList(),
        error = "";

  CandidateResponse.withError(String errorValue)
      : datas = [],
        error = errorValue;
}
