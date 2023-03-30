import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tech_test/bloc/blog_bloc.dart';
import 'package:tech_test/bloc/candidate_bloc.dart';
import 'package:tech_test/model/blog.dart';
import 'package:tech_test/model/candidate.dart';
import 'package:tech_test/style/app_colors.dart';
import 'package:tech_test/view/blog_detail_page.dart';
import 'package:tech_test/view/candidate_detail_page.dart';
import 'package:tech_test/view/widgets/blog_widget.dart';
import 'package:tech_test/view/widgets/candidates_widget.dart';
import 'package:tech_test/view/widgets/search_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Combine candidate and blog stream into one stream and listen it
  Stream homeStream = Rx.combineLatest2(
      candidateBloc.subject.stream, blogBloc.subject.stream, (a, b) {
    if (a.error != "" || b.error != "") {
      // throw String error if there is error in any stream
      return 'error';
    } else {
      // return list of Blog and Candidate data
      return [...a.datas, ...b.datas];
    }
  });

  String query = '';

  @override
  void initState() {
    super.initState();

    candidateBloc.getHomeData();
    blogBloc.getHomeData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: RefreshIndicator(
        onRefresh: () async {
          candidateBloc.getHomeData();
          blogBloc.getHomeData();
        },
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 50,
              ),
              _banner(),
              const SizedBox(
                height: 15,
              ),
              SearchComponent(
                text: query,
                onSearch: (text) {
                  candidateBloc.searchCandidate(text);
                  blogBloc.searchBlog(text);
                },
                hint: 'Search ...',
              ),
              _title("Candidates & Blogs"),
              StreamBuilder(
                stream: homeStream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting ||
                      snapshot.error == 'loading') {
                    // Show loading widget
                    return _buildLoadingWidget();
                  } else if (snapshot.hasData) {
                    // If data catch string error then show error widget
                    if (snapshot.data == 'error') {
                      return _buildErrorWidget(
                        onRetry: () {
                          candidateBloc.getHomeData();
                          blogBloc.getHomeData();
                        },
                      );
                    } else if (snapshot.data.isEmpty) {
                      // if empty list / array data build empty page
                      return _buildEmptyWidget();
                    } else {
                      // if have data list / array build page
                      snapshot.data?.shuffle();
                      return _buildHomeWidget(snapshot.data);
                    }
                  } else {
                    return const SizedBox();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Padding _title(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 15, left: 24, right: 24),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w700,
          fontSize: 16,
        ),
      ),
    );
  }

  Padding _banner() {
    return Padding(
      padding: const EdgeInsets.only(left: 24, right: 15),
      child: Image.asset('assets/banner.png'),
    );
  }

  Widget _buildHomeWidget(List? data) {
    return ListView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: data?.length,
      itemBuilder: (context, index) {
        if (data?[index].runtimeType == Candidate) {
          return CandidatesWidget(
            data: data?[index],
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CandidateDetailPage(
                  candidateData: data?[index],
                ),
              ),
            ),
          );
        } else if (data?[index].runtimeType == Blog) {
          return BlogWidget(
            data: data?[index],
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BlogDetailPage(
                  blogData: data?[index],
                ),
              ),
            ),
          );
        } else {
          return const SizedBox();
        }
      },
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

  Widget _buildEmptyWidget() {
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
          Image.asset('assets/notfound.png'),
          const SizedBox(
            height: 10,
          ),
          const Text(
            "Empty Data",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w700,
              fontSize: 24,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          const Text(
            "No data found",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.w400,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
