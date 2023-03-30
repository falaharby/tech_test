class Experience {
  final int id;
  final String status, jobTitle, companyName, industry;

  Experience(
      this.id, this.status, this.jobTitle, this.companyName, this.industry);

  Experience.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        status = json['status'],
        jobTitle = json['job_title'],
        companyName = json['company_name'],
        industry = json['industry'];
}

class ExperienceResponse {
  final List<Experience> datas;
  final String error;

  ExperienceResponse(this.datas, this.error);

  ExperienceResponse.fromJson(Map<String, dynamic> json)
      : datas = (json["results"] as List)
            .map((i) => Experience.fromJson(i))
            .toList(),
        error = "";

  ExperienceResponse.withError(String errorValue)
      : datas = [],
        error = errorValue;
}
