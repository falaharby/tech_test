import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tech_test/bloc/address_bloc.dart';
import 'package:tech_test/bloc/candidate_bloc.dart';
import 'package:tech_test/bloc/emails_bloc.dart';
import 'package:tech_test/bloc/experiences_bloc.dart';
import 'package:tech_test/model/candidate.dart';
import 'package:tech_test/style/app_colors.dart';

class CandidateDetailPage extends StatefulWidget {
  final Candidate candidateData;
  const CandidateDetailPage({super.key, required this.candidateData});

  @override
  State<CandidateDetailPage> createState() => _CandidateDetailPageState();
}

class _CandidateDetailPageState extends State<CandidateDetailPage> {
  Stream? candidatesStream;

  @override
  void initState() {
    setCandidateDetailStream();

    addressBloc.getData();
    emailsBloc.getData();
    experiencesBloc.getData();
    super.initState();
  }

  setCandidateDetailStream() {
    // Combine address, email and experience stream into one stream and listen it
    candidatesStream = Rx.combineLatest3(addressBloc.subject.stream,
        emailsBloc.subject.stream, experiencesBloc.subject.stream, (a, b, c) {
      if (a.error != "" || b.error != "" || c.error != "") {
        // throw String error if there is error in any stream
        return 'error';
      } else {
        // return Map data
        return candidateBloc.getDetailByID(
            widget.candidateData.id, a.datas, b.datas, c.datas);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(
              top: 20,
            ),
            child: Column(
              children: [
                _header(),
                const SizedBox(
                  height: 25,
                ),
                _candidateData(),
                StreamBuilder(
                  stream: candidatesStream,
                  builder: (context, snapshot) {
                    print(snapshot);
                    if (snapshot.connectionState == ConnectionState.waiting ||
                        snapshot.error == 'loading') {
                      return _buildLoadingWidget();
                    } else if (snapshot.hasData) {
                      if (snapshot.data == 'error') {
                        return _buildErrorWidget(
                          onRetry: () {
                            log('here');
                            addressBloc.getData();
                            emailsBloc.getData();
                            experiencesBloc.getData();
                          },
                        );
                      } else {
                        return _buildDetailCandidate(snapshot.data);
                      }
                    } else {
                      return const SizedBox();
                    }
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Padding _buildDetailCandidate(Map data) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(
                10,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'ADDRESS',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(
                  height: 18,
                ),
                _innerBlock(
                  'Address',
                  data['address'].address,
                ),
                _innerBlock(
                  'City',
                  data['address'].city,
                ),
                _innerBlock(
                  'State',
                  data['address'].state,
                ),
                _innerBlock(
                  'Zip Code',
                  data['address'].zipCode.toString(),
                  withoutDivider: true,
                ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(
                10,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'CONTACT',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(
                  height: 18,
                ),
                _innerBlock(
                  'Email',
                  data['contact'].emails,
                  onTap: () async {
                    candidateBloc.sendEmail(data['contact'].emails);
                  },
                ),
                _innerBlock(
                  'Phone',
                  data['contact'].phone,
                  withoutDivider: true,
                  onTap: () async {
                    candidateBloc.sendWhatsapp(data['contact'].phone);
                  },
                ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(
                10,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'EXPERIENCE',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(
                  height: 18,
                ),
                _innerBlock(
                  'Status',
                  data['experience'].status,
                ),
                _innerBlock(
                  'Job Title',
                  data['experience'].jobTitle,
                ),
                _innerBlock(
                  'Company Name',
                  data['experience'].companyName,
                ),
                _innerBlock(
                  'Industry',
                  data['experience'].industry,
                  withoutDivider: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingWidget() {
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 50),
        padding: const EdgeInsets.all(50),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const [
            CircularProgressIndicator(
              color: AppColors.mainColor,
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              "Loading ...",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorWidget({required VoidCallback onRetry}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset('assets/error.png'),
          const SizedBox(
            height: 10,
          ),
          const Text(
            "Oops! Something went wrong",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w700,
              fontSize: 18,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          const Text(
            "Error when getting data from server, please try again",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.w400,
              fontSize: 12,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
                backgroundColor: AppColors.mainColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('TRY AGAIN'))
        ],
      ),
    );
  }

  Widget _innerBlock(String title, String subtitle,
      {bool withoutDivider = false, VoidCallback? onTap}) {
    return Column(
      children: [
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: onTap,
                child: Text(
                  subtitle,
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: (onTap != null) ? Colors.blue[300] : Colors.black,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: (withoutDivider) ? 0 : 7,
        ),
        (withoutDivider) ? const SizedBox() : const Divider(thickness: 1),
        SizedBox(
          height: (withoutDivider) ? 0 : 7,
        ),
      ],
    );
  }

  Row _candidateData() {
    return Row(
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 0.45,
          height: 220,
          color: AppColors.mainColor.withOpacity(0.25),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipOval(
                  child: Container(
                    width: 110,
                    height: 110,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                        image: NetworkImage(widget.candidateData.photo),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: FadeInImage(
                      width: 110,
                      height: 110,
                      placeholder:
                          const AssetImage('assets/person_placeholder.jpg'),
                      placeholderFit: BoxFit.cover,
                      imageErrorBuilder: (context, error, stackTrace) =>
                          Image.asset(
                        'assets/person_placeholder.jpg',
                        width: 110,
                        height: 110,
                        fit: BoxFit.cover,
                      ),
                      image: NetworkImage(widget.candidateData.photo),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Text(
                    widget.candidateData.name,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: Container(
            padding: const EdgeInsets.only(
              right: 24,
              left: 24,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Gender',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 6.0, bottom: 15),
                  child: Text(
                    widget.candidateData.gender == 'm' ? 'Male' : 'Female',
                    style: const TextStyle(
                      color: AppColors.mainColor,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const Text(
                  'Birthday',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 6.0, bottom: 15),
                  child: Text(
                    DateFormat('dd MMM yyyy')
                        .format(widget.candidateData.birthday)
                        .toString(),
                    style: const TextStyle(
                      color: AppColors.mainColor,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const Text(
                  'Expired',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 6.0, bottom: 15),
                  child: Text(
                    DateFormat('dd MMM yyyy - HH:mm:ss')
                        .format(widget.candidateData.expired)
                        .toString(),
                    style: const TextStyle(
                      color: AppColors.mainColor,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Container _pointText(String text, {double paddingHorizontal = 25}) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 3, horizontal: paddingHorizontal),
      decoration: BoxDecoration(
        color: const Color(0xFFF4E6F6),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Color(0xFFB69FBA),
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Padding _header() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 24,
      ),
      child: Stack(
        children: [
          GestureDetector(
            child: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.black,
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          const Center(
            child: Text(
              'Candidate Detail',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
