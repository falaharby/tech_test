import 'package:flutter/material.dart';
import 'package:tech_test/style/app_colors.dart';

class SearchComponent extends StatefulWidget {
  final ValueChanged<String> onSearch;
  final String text;
  final String hint;
  const SearchComponent({
    Key? key,
    required this.text,
    required this.onSearch,
    required this.hint,
  }) : super(key: key);

  @override
  State<SearchComponent> createState() => _SearchComponentState();
}

class _SearchComponentState extends State<SearchComponent> {
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 24,
      ),
      width: double.infinity,
      height: 48,
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: controller,
              textInputAction: TextInputAction.search,
              onChanged: widget.onSearch,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.only(
                    top: 8, bottom: 8, left: 24, right: 15),
                hintText: widget.hint,
                hintStyle: TextStyle(fontSize: 13, color: Colors.grey[400]),
                filled: true,
                fillColor: Colors.white,
                border: const OutlineInputBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                    ),
                    borderSide: BorderSide.none),
              ),
            ),
          ),
          Container(
            height: 48,
            width: 50,
            decoration: const BoxDecoration(
              color: AppColors.mainColor,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
            ),
            child: const Icon(Icons.search, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
