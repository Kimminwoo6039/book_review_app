import 'package:book1/src/common/components/icon_statistic_widget.dart';
import 'package:book1/src/common/components/input_wiget.dart';
import 'package:book1/src/common/model/book_review_info.dart';
import 'package:book1/src/home/cubit/recently_review_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../common/components/app_font.dart';
import '../../common/cubit/authentication_cubit.dart';
import '../cubit/top_reviewer_cubit.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}


class _HomePageState extends State<HomePage> {
  var refrashController = RefreshController(initialRefresh: false);

  Future<void> _neverSatisfied() async {
    return showDialog<void>(
      //다이얼로그 위젯 소환
      context: context,
      barrierDismissible: false, // 다이얼로그 이외의 바탕 눌러도 안꺼지도록 설정
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: ListBody(
              //List Body를 기준으로 Text 설정
              children: <Widget>[
                Text('회원 탈퇴하시겠습니까 ? '),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: Text('확인'),
              onPressed: () {
                context.read<AuthenticationCubit>().deleteUser();
              },
            ),
            TextButton(
              child: Text('취소'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Container(
          padding: const EdgeInsets.all(15),
          child: BlocBuilder<AuthenticationCubit, AuthenticationState>(
              builder: (context, state) {
                return GestureDetector(
                  onTap: () {
                    context.read<AuthenticationCubit>().logout();
                  },
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.grey,
                        backgroundImage: state.user?.profile == null
                            ? Image
                            .asset('assets/images/default_avatar.png')
                            .image
                            : Image
                            .network(state.user!.profile!)
                            .image,
                      ),
                      const SizedBox(width: 15),
                      AppFont(state.user?.name ?? '', size: 16)
                    ],
                  ),
                );
              }),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: GestureDetector(
              onTap: () {
                _neverSatisfied();
              },
              child: AppFont(
                "회원 탈퇴",
                size: 14,
                color: const Color(0xffF4AA2B),
              ),
            ),
          ),
        ],
      ),
      body: SmartRefresher(
        controller: refrashController,
        onRefresh: () {
          context.read<TopReviewerCubit>().refresh();
          context.read<RecentlyCubit>().refresh();
          refrashController.refreshCompleted();
        },
        onLoading: () {
          refrashController.loadComplete();
        },
        child: SingleChildScrollView(
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.all(25),
              child: InputWidget(
                isEnabled: false,
                onTap: () {
                  context.push('/search');
                },
              ),
            ),
            _RecentlyReviewListWidget(),
            _TopReviewerListWidget(),
          ]),
        ),
      ),
    );
  }
}

class _TopReviewerListWidget extends StatelessWidget {
  const _TopReviewerListWidget({super.key});

  Widget _header() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 25),
      child: AppFont(
        'TOP 10 리뷰어',
        fontWeight: FontWeight.bold,
        size: 20,
      ),
    );
  }

  Widget _reviewers() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
      child: BlocBuilder<TopReviewerCubit, TopReviewerState>(
          builder: (context, state) {
            return Column(
              children: List.generate(
                state.results?.length ?? 0,
                    (index) {
                  return GestureDetector(
                    onTap: () {
                      context.push('/profile/${state.results![index].uid}');
                    },
                    child: Container(
                      height: 85,
                      margin: const EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(85),
                        color: const Color(0xff212121),
                      ),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: CircleAvatar(
                              backgroundColor: Colors.grey,
                              radius: 32,
                              backgroundImage:
                              Image
                                  .network(state.results?[index].profile ?? '')
                                  .image,
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                AppFont(
                                  state.results?[index].name ?? '',
                                  fontWeight: FontWeight.bold,
                                  size: 16,
                                ),
                                const SizedBox(height: 8),
                                AppFont(
                                  state.results?[index].discription ?? '',
                                  size: 12,
                                  color: const Color(
                                    0xff737373,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    IconStaticsticWidget(
                                      'assets/svg/icons/icon_journals.svg',
                                      state.results?[index].reviewCount ?? 0,
                                    ),
                                    const SizedBox(width: 20),
                                    IconStaticsticWidget(
                                      'assets/svg/icons/icon_people.svg',
                                      state.results?[index].followersCount ?? 0,
                                    ),
                                  ],
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [_header(), _reviewers()],
    );
  }
}

class _RecentlyReviewListWidget extends StatelessWidget {
  const _RecentlyReviewListWidget({super.key});

  Widget _header() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 25),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AppFont(
            '최신리뷰',
            fontWeight: FontWeight.bold,
            size: 20,
          ),
          // AppFont(
          //   '더보기',
          //   fontWeight: FontWeight.bold,
          //   size: 14,
          //   color: Color(0xffF4AA2B),
          // )
        ],
      ),
    );
  }

  Widget _bookView(BookReivewInfo bookInfo, BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.push('/info', extra: bookInfo.naverBookInfo);
      },
      behavior: HitTestBehavior.translucent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: Stack(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: MediaQuery
                      .of(context)
                      .size
                      .width * 0.5,
                  child: Image.network(
                    bookInfo.naverBookInfo?.image ?? '',
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 45,
                    padding: const EdgeInsets.only(left: 15),
                    color: Colors.black.withOpacity(0.5),
                    child: Row(children: [
                      SvgPicture.asset('assets/svg/icons/icon_star.svg',
                          width: 22),
                      const SizedBox(width: 5),
                      AppFont(
                        ((bookInfo.totalCount ?? 0) /
                            (bookInfo.reviewerUids?.length ?? 0))
                            .toStringAsFixed(2),
                        size: 16,
                        color: Color(0xffF4AA2B),
                      )
                    ]),
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 15),
          AppFont(
            bookInfo.naverBookInfo?.title ?? '',
            maxLine: 2,
            overflow: TextOverflow.ellipsis,
            size: 13,
            fontWeight: FontWeight.bold,
          ),
          const SizedBox(height: 10),
          AppFont(
            bookInfo.naverBookInfo?.author ?? '',
            size: 12,
            color: Color(0xff878787),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
        _header(),
        const SizedBox(height: 15),
        SizedBox(
          height: MediaQuery
              .of(context)
              .size
              .width * 0.5 + 100,
          child: Padding(
            padding: const EdgeInsets.only(left: 25),
            child: BlocBuilder<RecentlyCubit, RecentlyState>(
                builder: (context, state) {
                  return PageView.builder(
                    padEnds: false,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: EdgeInsets.only(right: 25),
                        child: _bookView(state.result![index], context),
                      );
                    },
                    controller: PageController(viewportFraction: 0.45),
                    itemCount: state.result?.length ?? 0,
                  );
                }),
          ),
        )
      ],
    );
  }
}
