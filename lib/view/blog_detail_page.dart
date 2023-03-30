import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tech_test/model/blog.dart';
import 'package:tech_test/style/app_colors.dart';

class BlogDetailPage extends StatelessWidget {
  final Blog blogData;
  const BlogDetailPage({super.key, required this.blogData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 20,
            ),
            child: Column(
              children: [
                Stack(
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
                        'Blog Detail',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: FadeInImage(
                    width: double.infinity,
                    height: 220,
                    placeholder:
                        const AssetImage('assets/blog_placeholder2.png'),
                    placeholderFit: BoxFit.cover,
                    imageErrorBuilder: (context, error, stackTrace) =>
                        Image.asset(
                      'assets/blog_placeholder2.png',
                      width: double.infinity,
                      height: 220,
                      fit: BoxFit.cover,
                    ),
                    image: NetworkImage(blogData.photo),
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                _tagWidget(blogData.tag),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  blogData.title,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                _authorTimeWidget(),
                const SizedBox(
                  height: 15,
                ),
                Text(
                  blogData.subtitle,
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12.5,
                    height: 1.7,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _tagWidget(String tag) {
    List tags = tag.split(", ");
    return SizedBox(
      width: double.infinity,
      child: Wrap(
        spacing: 5,
        alignment: WrapAlignment.start,
        children: tags
            .map(
              (e) => Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 2, horizontal: 12),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 246, 235, 230),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  e,
                  style: const TextStyle(
                    color: Color.fromARGB(255, 186, 163, 159),
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  Row _authorTimeWidget() {
    return Row(
      children: [
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 3,
          children: [
            const Icon(
              Icons.person_outline,
              color: Colors.grey,
              size: 16,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 1.7),
              child: Text(
                blogData.author,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 11,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(
          width: 15,
        ),
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 3,
          children: [
            const Icon(
              Icons.access_time_outlined,
              color: Colors.grey,
              size: 16,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 1.7),
              child: Text(
                DateFormat('dd MMM yyyy').format(blogData.createdAt).toString(),
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 11,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
