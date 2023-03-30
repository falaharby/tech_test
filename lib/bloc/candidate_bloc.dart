import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tech_test/model/address.dart';
import 'package:tech_test/model/candidate.dart';
import 'package:tech_test/model/emails.dart';
import 'package:tech_test/model/experience.dart';
import 'package:tech_test/repository/repository.dart';
import 'package:url_launcher/url_launcher_string.dart';

class CandidateBloc {
  final TechRepository _repository = TechRepository();
  final BehaviorSubject<CandidateResponse> _subject =
      BehaviorSubject<CandidateResponse>();
  CandidateResponse? candidateList;

  getHomeData() async {
    // sink an error with String loading to make state listen into loading
    _subject.sink.addError('loading');
    candidateList = await _repository.getCandidates();

    _subject.sink.add(candidateList!);
  }

  Future searchCandidate(String query) async {
    final options = await filterData(query);

    // sink filteredData
    _subject.sink.add(options);
  }

  Future<CandidateResponse> filterData(String query) async {
    final listData = candidateList;
    return CandidateResponse(
        listData!.datas.where((element) {
          // Filter by name
          final text = element.name.toLowerCase();
          final searchLower = query.toLowerCase();

          return text.contains(searchLower);
        }).toList(),
        '');
  }

  // Filter address, email and experience by selected candidate id and return Map data
  Map getDetailByID(int id, List<Address> address, List<Emails> email,
      List<Experience> experience) {
    Address addressData =
        address.where((element) => element.id == id).toList()[0];

    Emails emailData = email.where((element) => element.id == id).toList()[0];

    Experience experienceData =
        experience.where((element) => element.id == id).toList()[0];

    return {
      'address': addressData,
      'contact': emailData,
      'experience': experienceData
    };
  }

  Future<void> sendWhatsapp(String phone) async {
    // Remove + - and space from number
    String number = phone;
    if (number[0] == '+') {
      number = number.replaceFirst("+", "");
    }
    number = number.replaceAll("-", "");
    number = number.replaceAll(" ", "");

    // Encode string into url
    String wa = Uri.encodeFull("https://wa.me/$number?text=Hi i am MK company");

    launchUrlString(wa, mode: LaunchMode.externalApplication);
  }

  Future<void> sendEmail(String email) async {
    FlutterEmailSender.send(
      Email(
        recipients: [email],
        subject: 'Tech Test A Job Thing',
        body: 'Hi i am MK company',
      ),
    );
  }

  BehaviorSubject<CandidateResponse> get subject => _subject;
}

final candidateBloc = CandidateBloc();
