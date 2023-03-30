import 'package:rxdart/rxdart.dart';
import 'package:tech_test/model/blog.dart';
import 'package:tech_test/repository/repository.dart';

class BlogBloc {
  final TechRepository _repository = TechRepository();
  final BehaviorSubject<BlogResponse> _subject =
      BehaviorSubject<BlogResponse>();
  BlogResponse? blogList;

  getHomeData() async {
    // sink an error with String loading to make state listen into loading
    _subject.sink.addError('loading');
    blogList = await _repository.getBlogs();

    _subject.sink.add(blogList!);
  }

  Future searchBlog(String query) async {
    final options = await filterData(query);

    // sink filteredData
    _subject.sink.add(options);
  }

  Future<BlogResponse> filterData(String query) async {
    final listData = blogList;
    return BlogResponse(
        listData!.datas.where((element) {
          // Filter by author and blog title
          final authorText = element.author.toLowerCase();
          final titleText = element.title.toLowerCase();
          final searchLower = query.toLowerCase();

          return authorText.contains(searchLower) ||
              titleText.contains(searchLower);
        }).toList(),
        '');
  }

  BehaviorSubject<BlogResponse> get subject => _subject;
}

final blogBloc = BlogBloc();
