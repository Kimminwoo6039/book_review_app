import 'package:book1/src/common/model/naver_book_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'app_font.dart';

class BookReviewHeaderWidget extends StatelessWidget {
  final NaverBookInfo naverBookInfo;
  final Widget reviewCountDisplayWidget;
  const BookReviewHeaderWidget(this.naverBookInfo,{super.key,required this.reviewCountDisplayWidget});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(25.0),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(7),
            child: SizedBox(
                width: 71,
                height: 106,
                child: Image.network(
                  naverBookInfo.image ?? '',
                  fit: BoxFit.fill,
                )),
          ),
          SizedBox(
            width: 15,
          ),
          Expanded(
            //어디 영역까지 사용할거냐
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AppFont(
                  naverBookInfo.title ?? '',
                  size: 16,
                  fontWeight: FontWeight.bold,
                ),
                SizedBox(
                  height: 5,
                ),
                AppFont(
                  naverBookInfo.author ?? '',
                  size: 12,
                  color: Color(0xff878787),
                ),
                const SizedBox(
                  height: 10,
                ),
              reviewCountDisplayWidget
              ],
            ),
          )
        ],
      ),
    );
  }
}
