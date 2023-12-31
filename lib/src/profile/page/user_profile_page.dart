import 'package:book1/src/common/components/app_divider.dart';
import 'package:book1/src/common/components/icon_statistic_widget.dart';
import 'package:book1/src/common/cubit/authentication_cubit.dart';
import 'package:book1/src/common/enum/common_state_status.dart';
import 'package:book1/src/profile/cubit/user-review_cubit.dart';
import 'package:book1/src/profile/cubit/user_profile_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

import '../../common/components/app_font.dart';

class UserProfilePage extends StatelessWidget {
  const UserProfilePage({super.key});

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
        title: BlocBuilder<UserProfileCubit, UserProfileState>(
            builder: (context, state) {
          return AppFont(
            "${state.userModel?.name ?? ''} 리뷰어",
            size: 18,
          );
        }),
        centerTitle: true,
        actions: [
          GestureDetector(
            onTap: () {
              var myUid = context.read<AuthenticationCubit>().state.user!.uid;
              context.read<UserProfileCubit>().followToggleEvent(myUid!);
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 20),
              child: BlocBuilder<UserProfileCubit,UserProfileState>(
                builder: (context,state) {
                  var myUid = context.read<AuthenticationCubit>().state.user!.uid;
                  var isFollowing = state.userModel?.followers?.contains(myUid) ?? false;
                  return SvgPicture.asset(isFollowing ? 'assets/svg/icons/icon_follow_on.svg' :'assets/svg/icons/icon_follow_off.svg');
                }
              ),
            ),
          )
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverList(
            delegate: SliverChildListDelegate([
              const _profileInfo(),
              const _Danger(),
              const AppDivider(),
              const _ReviewList(),
            ]),
          ),
        ],
      ),
    );
  }
}

class _Danger extends StatelessWidget {
  const _Danger({super.key});

  Future<Widget> message(BuildContext context) async {
    return await showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          content: AppFont(
            "사용자를 신고하였습니다.",
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
  }

  @override
  Widget build(BuildContext context) {
    return  Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 18,right: 10),
          child: GestureDetector (
            onTap: (){
              message(context);
            },
            child: AppFont(
              "사용자 신고하기",
              size: 14,
              color: const Color(0xffF4AA2B),
            ),
          ),
        ),
      ],
    );
  }
}


class _ReviewList extends StatelessWidget {
  const _ReviewList({super.key});

  @override
  Widget build(BuildContext context) {
    var state = context.watch<UserReviewCubit>().state;

    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      // 안에서 스크롤바를 사용안한다..
      shrinkWrap: true,
      // hasSize 오류 나올때
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 5,
        mainAxisSpacing: 5,
        mainAxisExtent: 270,
      ),
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: (){
            context.push("/review-detail/${state.results![index].bookId!}/${state.results![index].reviewerUid}" , extra: state.results![index].naverBookInfo!);
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 10,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(7),
                  child: Image.network(
                    state.results?[index].naverBookInfo?.image ?? '',
                    fit: BoxFit.cover,
                    height: 150,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5,horizontal: 10),
                child: AppFont(
                  state.results?[index].naverBookInfo?.title ?? '',
                  maxLine: 2,
                  fontWeight: FontWeight.bold,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5,horizontal: 10),
                child: AppFont(
                  state.results?[index].naverBookInfo?.author ?? '',
                  size: 12,
                  color: Color(0Xff878787),
                ),
              ),
            ],
          ),
        );
      },
      itemCount: state.results!.length,
    );
  }
}

class _profileInfo extends StatelessWidget {
  const _profileInfo({super.key});

  @override
  Widget build(BuildContext context) {
    var cubit = context.watch<UserProfileCubit>();
    return Column(
      children: [
        SizedBox(
          height: 20,
        ),
        cubit.state.status == CommonStatus.loaded
            ? CircleAvatar(
                radius: 33,
                backgroundColor: Colors.grey,
                backgroundImage: cubit.state.userModel?.profile == null
                    ? Image.asset('assets/images/default_avatar.png').image
                    : Image.network(cubit.state.userModel?.profile ?? '').image,
              )
            : Center(
                child: const CircularProgressIndicator(
                strokeWidth: 1,
              )),
        SizedBox(
          height: 20,
        ),
        AppFont(cubit.state.userModel?.discription ?? ''),
        SizedBox(
          height: 30,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 1번
            Container(
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(7),
                border: Border.all(color: Color(0xff5F5F5F)),
              ),
              child: BlocBuilder<UserReviewCubit,UserReviewState>(
                builder: (context, state) {
                  return IconStaticsticWidget('assets/svg/icons/icon_journals.svg', state.results!.length);
                },
              ),
            ),
            // 2번
            SizedBox(
              width: 5,
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(7),
                border: Border.all(color: Color(0xff5F5F5F)),
              ),
              child:   BlocBuilder<UserProfileCubit,UserProfileState>(
                builder: (context, state) {
                  return IconStaticsticWidget('assets/svg/icons/icon_people.svg', state.userModel?.followers?.length ?? 0);
                },
              ),
            ),


          ],
        )
      ],
    );
  }
}
