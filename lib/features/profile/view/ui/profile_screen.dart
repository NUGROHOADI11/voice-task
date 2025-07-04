import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../shared/styles/color_style.dart';
import '../../../../shared/widgets/custom_appbar.dart';
import '../components/about.dart';
import '../components/list_item_profile.dart';
import '../components/header.dart';
import '../components/section_title.dart';
import '../components/sosmed.dart';
import '../components/stat.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ColorStyle.white,
        appBar: CustomAppBar(
          title: Text('Profile'.tr),
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildHeader(context),
              buildAboutMe(),
              buildStats(),
              ...buildListItem(context),
              SizedBox(height: 20.h),
              buildSectionTitle('Our Social Media'.tr),
              SizedBox(height: 10.h),
              ...buildSocialMediaItems(),
            ],
          ),
        ));
  }
}
