import 'package:book1/src/common/components/app_font.dart';
import 'package:book1/src/common/components/book_review_header_wiget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

import '../../../common/components/app_divider.dart';
import '../../../common/model/naver_book_info.dart';

class ReviewDetailPage extends StatelessWidget {
  final NaverBookInfo naverBookInfo;

  const ReviewDetailPage(this.naverBookInfo, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: context.pop,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: SvgPicture.asset('assets/svg/icons/icon_arrow_back.svg'),
          ),
        ),
        title: AppFont(
          "리뷰",
          size: 18,
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          BookReviewHeaderWidget(
            naverBookInfo,
            reviewCountDisplayWidget: Row(
              children: [
                SvgPicture.asset(
                  "assets/svg/icons/icon_star.svg",
                  width: 22,
                ),
                SizedBox(
                  width: 5,
                ),
                const AppFont(
                  '4.6',
                  size: 12,
                  color: Color(0xffF4AA2B),
                ),
              ],
            ),
          ),
          AppDivider(),
          Expanded(
            child: _ReviewInfoWidget(),
          ),
        ],
      ),
    );
  }
}

class _ReviewInfoWidget extends StatelessWidget {
  const _ReviewInfoWidget({super.key});

  Widget _profile() {
    return Row(
      children: [
        CircleAvatar(
          radius: 33,
          backgroundColor: Colors.grey,
          backgroundImage:
              Image.asset('assets/images/default_avatar.png').image,
        ),
        const SizedBox(
          width: 15,
        ),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppFont(
                "리뷰작성",
                size: 18,
                color: Color(0xffC9C9C9),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppFont(
                    "공감 0개",
                    fontWeight: FontWeight.bold,
                  ),
                  AppFont(
                    "2023.11.25",
                    size: 12,
                    color: Color(0xff878787),
                  ),
                ],
              ),
            ],
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _profile(),
          const SizedBox(height: 30,),
          AppFont(
            '리뷰내용',
            size: 14,
            color: const Color(0xffA7A7A7),
          ),
          GestureDetector(
            onTap: (){},
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 50),
              child: SvgPicture.asset(
                'assets/svg/icons/icon_liked.svg',
                width: 30,
              ),
            ),
          )
        ],
      ),
    );
  }
}
