import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tech_test/model/blog.dart';

class BlogWidget extends StatelessWidget {
  final VoidCallback onPressed;
  final Blog data;
  const BlogWidget({super.key, required this.data, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 220,
        width: double.infinity,
        margin: const EdgeInsets.only(
          bottom: 10,
          right: 24,
          left: 24,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          // color: Colors.blue,
        ),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: FadeInImage(
                width: double.infinity,
                height: 220,
                placeholder: const AssetImage('assets/blog_placeholder.png'),
                placeholderFit: BoxFit.cover,
                imageErrorBuilder: (context, error, stackTrace) => Image.asset(
                  'assets/blog_placeholder.png',
                  width: double.infinity,
                  height: 220,
                  fit: BoxFit.cover,
                ),
                image: NetworkImage(data.photo),
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              bottom: 10,
              left: 10,
              right: 10,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Column(
                  children: [
                    _tagWidget(data.tag),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      data.title,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      data.subtitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 9,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    _authorTimeWidget(),
                  ],
                ),
              ),
            )
          ],
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
                    fontSize: 7.5,
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
              size: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 1.7),
              child: Text(
                data.author,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 8,
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
              size: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 1.7),
              child: Text(
                DateFormat('dd MMM yyyy').format(data.createdAt).toString(),
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 8,
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
