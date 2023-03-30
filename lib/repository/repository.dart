import 'package:dio/dio.dart';
import 'package:tech_test/model/address.dart';
import 'package:tech_test/model/blog.dart';
import 'package:tech_test/model/candidate.dart';
import 'package:tech_test/model/emails.dart';
import 'package:tech_test/model/experience.dart';

class TechRepository {
  static String mainUrl = "https://private-b9a758-candidattest.apiary-mock.com";
  final Dio _dio = Dio();
  var candidatesUrl = '$mainUrl/candidates';
  var blogUrl = '$mainUrl/blogs';
  var addressUrl = '$mainUrl/address';
  var emailUrl = '$mainUrl/emails';
  var experienceUrl = '$mainUrl/experiences';

  Future<CandidateResponse> getCandidates() async {
    try {
      Response response = await _dio.get(candidatesUrl);
      return CandidateResponse.fromJson(response.data);
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return CandidateResponse.withError("$error");
    }
  }

  Future<BlogResponse> getBlogs() async {
    try {
      Response response = await _dio.get(blogUrl);
      return BlogResponse.fromJson(response.data);
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return BlogResponse.withError("$error");
    }
  }

  Future<AddressResponse> getAddress() async {
    try {
      Response response = await _dio.get(addressUrl);
      return AddressResponse.fromJson(response.data);
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return AddressResponse.withError("$error");
    }
  }

  Future<EmailsResponse> getEmails() async {
    try {
      Response response = await _dio.get(emailUrl);
      return EmailsResponse.fromJson(response.data);
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return EmailsResponse.withError("$error");
    }
  }

  Future<ExperienceResponse> getExperiences() async {
    try {
      Response response = await _dio.get(experienceUrl);
      return ExperienceResponse.fromJson(response.data);
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return ExperienceResponse.withError("$error");
    }
  }
}
