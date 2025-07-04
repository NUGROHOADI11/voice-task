import 'package:flutter/material.dart';

import 'profile_item.dart';

List<Widget> buildSocialMediaItems() {
  const socialMedia = [
    {'icon': Icons.apple, 'title': 'Instagram'},
    {'icon': Icons.telegram, 'title': 'Youtube'},
    {'icon': Icons.facebook, 'title': 'Facebook'},
    {'icon': Icons.tiktok, 'title': 'X'},
  ];

  return socialMedia.map((media) {
    return buildProfileItem(
      icon: media['icon'] as IconData,
      title: media['title'] as String,
      showTrailing: false,
      showDivider: false,
      onTap: () {},
    );
  }).toList();
}


