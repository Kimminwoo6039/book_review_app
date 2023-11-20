import 'package:book1/src/app.dart';
import 'package:book1/src/common/components/app_divider.dart';
import 'package:book1/src/common/components/app_font.dart';
import 'package:book1/src/common/components/btn.dart';
import 'package:book1/src/common/model/naver_book_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class BookInfoPage extends StatelessWidget {
  final NaverBookInfo naverBookInfo;

  const BookInfoPage(this.naverBookInfo, {super.key});

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
          "책 소개",
          size: 18,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(
              height: 20,
            ),
            _BookDisplayLayer(naverBookInfo),
            AppDivider(),
            _BookSimpleInfoLayer(naverBookInfo),
            AppDivider(),
            _ReviewrLayer(),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding:  EdgeInsets.only(left: 20,right: 20,top: 20,bottom: 20 + MediaQuery.of(context).padding.bottom),
        child: Btn(onTap: (){}, text: '리뷰하기'),
      ),
    );
  }
}

class _ReviewrLayer extends StatelessWidget {
  const _ReviewrLayer({super.key});

  Widget _noneReviewr() {
    return const Center(
      child: AppFont(
        '아직 리뷰가 없습니다',
        size: 17,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const AppFont(
            '리뷰어',
            size: 18,
            fontWeight: FontWeight.bold,
          ),
          const SizedBox(
            height: 20,
          ),
          SizedBox(
            child: _noneReviewr(),
            height: 70,
          ), // 없을수도 있으니 분기처리 함수로
        ],
      ),
    );
  }
}

class _BookSimpleInfoLayer extends StatelessWidget {
  final NaverBookInfo naverBookInfo;

  const _BookSimpleInfoLayer(this.naverBookInfo, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const AppFont(
            '간단소개',
            size: 18,
            fontWeight: FontWeight.bold,
          ),
          const SizedBox(
            height: 20,
          ),
          AppFont(
            naverBookInfo.description ?? '',
            size: 13,
            lineHeight: 1.5,
            color: Color(0xff898989),
          ),
        ],
      ),
    );
  }
}

class _BookDisplayLayer extends StatelessWidget {
  final NaverBookInfo naverBookInfo;

  const _BookDisplayLayer(this.naverBookInfo, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ClipRRect(
          // 라운드
          borderRadius: BorderRadius.circular(7),
          child: SizedBox(
            child: Image.network(
              naverBookInfo.image ?? '',
              fit: BoxFit.cover,
            ),
            width: 152,
            height: 227,
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset('assets/svg/icons/icon_star.svg'),
            SizedBox(
              width: 5,
            ),
            const AppFont(
              '8.88',
              size: 16,
              color: Color(0xffF4AA2B),
            ),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Padding(
          padding:
              const EdgeInsets.only(top: 0, bottom: 0, left: 35, right: 35),
          child: AppFont(
            naverBookInfo.title ?? '',
            size: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(
          height: 5,
        ),
        AppFont(
          naverBookInfo.author ?? '',
          size: 12,
          color: Color(0xff878787),
        ),
      ],
    );
  }
}
