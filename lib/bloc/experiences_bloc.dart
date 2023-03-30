import 'package:rxdart/rxdart.dart';
import 'package:tech_test/model/experience.dart';
import 'package:tech_test/repository/repository.dart';

class ExperiencesBloc {
  final TechRepository _repository = TechRepository();
  final BehaviorSubject<ExperienceResponse> _subject =
      BehaviorSubject<ExperienceResponse>();
  ExperienceResponse? experienceList;

  getData() async {
    // sink an error with String loading to make state listen into loading
    _subject.sink.addError('loading');
    experienceList = await _repository.getExperiences();

    _subject.sink.add(experienceList!);
  }

  BehaviorSubject<ExperienceResponse> get subject => _subject;
}

final experiencesBloc = ExperiencesBloc();
