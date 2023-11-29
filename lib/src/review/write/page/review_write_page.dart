import 'package:book1/src/common/components/app_divider.dart';
import 'package:book1/src/common/components/book_review_header_wiget.dart';
import 'package:book1/src/common/components/loading.dart';
import 'package:book1/src/common/components/review_slider_bar.dart';
import 'package:book1/src/common/cubit/authentication_cubit.dart';
import 'package:book1/src/common/enum/common_state_status.dart';
import 'package:book1/src/common/model/naver_book_info.dart';
import 'package:book1/src/review/write/cubit/review_write_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

import '../../../common/components/app_font.dart';
import '../../../common/components/btn.dart';

class ReviewWritePage extends StatelessWidget {
  NaverBookInfo naverBookInfo;

  ReviewWritePage(this.naverBookInfo, {super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
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
              BookReviewHeaderWidget(naverBookInfo, reviewCountDisplayWidget:
                  BlocBuilder<ReviewWriteCubit, ReviewWriteState>(
                builder: (context, state) {
                  return ReviewSliderBar(
                    initValue: state.review?.value ?? 0,
                    onChange: context.read<ReviewWriteCubit>().changeValue,
                  );
                },
              )),
              AppDivider(),
              Expanded(child: BlocBuilder<ReviewWriteCubit, ReviewWriteState>(
                  // buildWhen: (previous, current) => current.isEditModel != previous.isEditModel,
                  builder: (context, state) {
                return _ReviewBox(
                  initReview: state.review?.review,
                );
              })),
            ],
          ),
          bottomNavigationBar: Padding(
            padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom: 20 + MediaQuery.of(context).padding.bottom),
            child: Btn(
              onTap: context.read<ReviewWriteCubit>().save,
              text: '저장',
            ),
          ),
        ),
        BlocConsumer<ReviewWriteCubit, ReviewWriteState>(
          // 메시지용 리스너
          listener: (context, state) async {
            if (state.status == CommonStatus.loaded && state.message != null) {
              await showCupertinoDialog(
                context: context,
                builder: (context) {
                  return CupertinoAlertDialog(
                    content: AppFont(
                      state.message ?? '',
                      size: 18,
                      color: Colors.black,
                    ),
                    actions: [
                      CupertinoDialogAction(
                          child: AppFont(
                            "확인",
                            textAlign: TextAlign.center,
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                          onPressed: () {
                            context.pop(context);
                          })
                    ],
                  );
                },
              );
              await context.read<AuthenticationCubit>().updateReviewCounts(); // 카운트 증가
              context.pop<bool?>(true); // 재로드!!
            }
          },
          // 로딩
          builder: (context, state) {
            if (state.status == CommonStatus.loading) {
              return Loading();
            } else {
              return Container();
            }
          },
        )
      ],
    );
  }
}

class _ReviewBox extends StatefulWidget {
  final String? initReview;

  _ReviewBox({super.key, this.initReview});

  @override
  State<_ReviewBox> createState() => _ReviewBoxState();
}

class _ReviewBoxState extends State<_ReviewBox> {
  TextEditingController editingController = TextEditingController();

  @override
  void didUpdateWidget(covariant _ReviewBox oldWidget) {
    super.didUpdateWidget(oldWidget);
    editingController.text = widget.initReview ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: TextField(
          // 전체화면 텍스트필드
          maxLines: null,
          controller: editingController,
          decoration: const InputDecoration(
            border: InputBorder.none,
            hintText: "리뷰를 입력해주세요",
            contentPadding: EdgeInsets.symmetric(horizontal: 25),
            hintStyle: TextStyle(
              color: Color(0xff585858),
            ),
          ),
          onChanged: context.read<ReviewWriteCubit>().changeReview,
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}

