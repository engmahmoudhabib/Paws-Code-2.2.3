import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_app/config/AppFactory.dart';
import 'package:flutter_app/ui/screen/BaseStateWidget.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter/rendering.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:shimmer/shimmer.dart';

class PhotoViewGalleryFragment extends StatefulWidget {
  final List<dynamic> images;

  PhotoViewGalleryFragment(this.images);

  @override
  PhotoViewGalleryState createState() => PhotoViewGalleryState();
}

class PhotoViewGalleryState
    extends BaseStatefulState<PhotoViewGalleryFragment> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.white,
        brightness: Brightness.light,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: AppFactory.getColor('primary', toString()),
          ),
          onPressed: () => Navigator.pop(context, true),
        ),
      ),
      body: Container(
          child: PhotoViewGallery.builder(
        scrollPhysics: const BouncingScrollPhysics(),
        builder: (BuildContext context, int index) {
          return PhotoViewGalleryPageOptions(
            minScale: PhotoViewComputedScale.contained * 0.9,
            maxScale: PhotoViewComputedScale.contained * 0.9,
            imageProvider:
                CachedNetworkImageProvider(widget.images[index]['url'] ?? ''),
            initialScale: PhotoViewComputedScale.contained * 0.9,
          );
        },
        itemCount: widget.images.length,
        loadingBuilder: (context, event) => ImageLoaderPlaceholder(),
      )),
    );
  }
}
