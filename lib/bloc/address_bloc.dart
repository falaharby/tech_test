import 'dart:developer';

import 'package:rxdart/rxdart.dart';
import 'package:tech_test/model/address.dart';
import 'package:tech_test/repository/repository.dart';

class AddressBloc {
  final TechRepository _repository = TechRepository();
  final BehaviorSubject<AddressResponse> _subject =
      BehaviorSubject<AddressResponse>();
  AddressResponse? addressList;

  getData() async {
    // sink an error with String loading to make state listen into loading
    _subject.sink.addError('loading');
    addressList = await _repository.getAddress();

    _subject.sink.add(addressList!);
  }

  BehaviorSubject<AddressResponse> get subject => _subject;
}

final addressBloc = AddressBloc();
