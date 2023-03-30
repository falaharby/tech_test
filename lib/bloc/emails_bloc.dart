import 'package:rxdart/rxdart.dart';
import 'package:tech_test/model/emails.dart';
import 'package:tech_test/repository/repository.dart';

class EmailsBloc {
  final TechRepository _repository = TechRepository();
  final BehaviorSubject<EmailsResponse> _subject =
      BehaviorSubject<EmailsResponse>();
  EmailsResponse? emailsList;

  getData() async {
    // sink an error with String loading to make state listen into loading
    _subject.sink.addError('loading');
    emailsList = await _repository.getEmails();

    _subject.sink.add(emailsList!);
  }

  BehaviorSubject<EmailsResponse> get subject => _subject;
}

final emailsBloc = EmailsBloc();
