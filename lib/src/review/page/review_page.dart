import 'package:book1/src/common/components/app_divider.dart';
import 'package:book1/src/common/components/review_slider_bar.dart';
import 'package:book1/src/common/model/naver_book_info.dart';
import 'package:book1/src/review/cubit/review_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

import '../../common/components/app_font.dart';
import '../../common/components/btn.dart';

class ReviewPage extends StatelessWidget {
  NaverBookInfo naverBookInfo;

  ReviewPage(this.naverBookInfo, {super.key});

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
          "리뷰 작성",
          size: 18,
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          _HeaderBookInfo(naverBookInfo),
          AppDivider(),
          Expanded(child: _ReviewBox()),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: 20 + MediaQuery.of(context).padding.bottom),
        child: Btn(
          onTap: context.read<ReviewCubit>().save,
          text: '저장',
        ),
      ),
    );
  }
}

class _ReviewBox extends StatelessWidget {
  _ReviewBox({super.key});

  @override
  Widget build(BuildContext context) {
    return TextField(
      // 전체화면 텍스트필드
      maxLines: null,
      decoration: const InputDecoration(
        border: InputBorder.none,
        hintText: "리뷰를 입력해주세요",
        contentPadding: EdgeInsets.symmetric(horizontal: 25),
        hintStyle: TextStyle(
          color: Color(0xff585858),
        ),
      ),
      onChanged: context.read<ReviewCubit>().changeReview,
      style: TextStyle(color: Colors.white),
    );
  }
}

class _HeaderBookInfo extends StatelessWidget {
  final NaverBookInfo naverBookInfo;

  _HeaderBookInfo(this.naverBookInfo, {super.key});

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
                SizedBox(
                  height: 10,
                ),
                ReviewSliderBar(
                  onChange: context.read<ReviewCubit>().changeValue,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
