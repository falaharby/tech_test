import 'package:flutter/material.dart';
import 'package:tech_test/model/candidate.dart';
import 'package:intl/intl.dart';

class CandidatesWidget extends StatelessWidget {
  final VoidCallback onPressed;
  final Candidate data;
  const CandidatesWidget({
    super.key,
    required this.data,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        margin: const EdgeInsets.only(
          bottom: 10,
          left: 24,
          right: 24,
        ),
        padding: const EdgeInsets.symmetric(
          vertical: 15,
          horizontal: 24,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    image: NetworkImage(data.photo),
                    fit: BoxFit.cover,
                  ),
                ),
                child: FadeInImage(
                  placeholder:
                      const AssetImage('assets/person_placeholder.jpg'),
                  placeholderFit: BoxFit.cover,
                  imageErrorBuilder: (context, error, stackTrace) =>
                      Image.asset(
                    'assets/person_placeholder.jpg',
                    fit: BoxFit.cover,
                  ),
                  image: NetworkImage(data.photo),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 3, horizontal: 25),
                    decoration: BoxDecoration(
                      color: data.gender == "m"
                          ? const Color.fromARGB(255, 224, 246, 236)
                          : const Color(0xFFF4E6F6),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      data.gender == "m" ? 'Male' : 'Female',
                      style: TextStyle(
                        color: data.gender == "m"
                            ? const Color.fromARGB(255, 104, 193, 144)
                            : const Color(0xFFB69FBA),
                        fontSize: 9,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 6,
                  ),
                  Text(
                    data.name,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(
                    height: 3,
                  ),
                  Row(
                    children: [
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 3,
                        children: [
                          Icon(
                            Icons.cake_outlined,
                            color: Colors.grey[400],
                            size: 12,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 2.5),
                            child: Text(
                              DateFormat('dd MMM yyyy')
                                  .format(data.birthday)
                                  .toString(),
                              style: TextStyle(
                                color: Colors.grey[400],
                                fontSize: 10,
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
                          Icon(
                            Icons.access_time_outlined,
                            color: Colors.grey[400],
                            size: 12,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 2.5),
                            child: Text(
                              DateFormat('dd MMM yyyy - HH:mm:ss')
                                  .format(data.expired)
                                  .toString(),
                              style: TextStyle(
                                color: Colors.grey[400],
                                fontSize: 10,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
