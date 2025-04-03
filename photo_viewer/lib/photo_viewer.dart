import 'dart:io';

import 'package:photo_viewer/image_wheel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class HeroPageRoute extends MaterialPageRoute<void> {
  HeroPageRoute({required super.builder}) : super(fullscreenDialog: true) {
    assert(opaque);
  }

  @override
  Duration get transitionDuration => const Duration(milliseconds: 400);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
    const double begin = 0;
    const double end = 1;
    const Curve curve = Curves.ease;

    final Tween<double> tween = Tween(begin: begin, end: end);
    final CurvedAnimation curvedAnimation = CurvedAnimation(parent: animation, curve: curve);

    return FadeTransition(opacity: tween.animate(curvedAnimation), child: child);
  }
}

class PhotoViewerPage extends StatefulWidget {
  const PhotoViewerPage({
    super.key,
    required this.initialFileName,
    this.backgroundColor,
    this.title,
    this.subtitle,
    required this.images,
  });

  final String initialFileName;
  final Color? backgroundColor;
  final Widget? title;
  final Widget? subtitle;
  final List<List<String>> images;

  @override
  State<PhotoViewerPage> createState() => _PhotoViewerPageState();
}

class _PhotoViewerPageState extends State<PhotoViewerPage> {
  late PageController controller1 = PageController(
    initialPage: widget.images.expand((e) => e).toList().indexWhere((element) => element == widget.initialFileName),
  );
  late ImageWheelScrollController controller2 = ImageWheelScrollController(
    initialItem: widget.images.expand((e) => e).toList().indexWhere((element) => element == widget.initialFileName),
    images: widget.images.map((e) => e.length).toList(),
  );

  @override
  void dispose() {
    controller1.dispose();
    controller2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.backgroundColor,
      appBar: AppBar(
        toolbarHeight: 44,
        backgroundColor: widget.backgroundColor,
        centerTitle: true,
        leading: CupertinoButton.tinted(
          onPressed: () => Navigator.pop(context),
          padding: EdgeInsets.zero,
          sizeStyle: CupertinoButtonSize.medium,
          child: const Icon(CupertinoIcons.chevron_back),
        ),
        title: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DefaultTextStyle(
              style: TextStyle(
                color: ThemeData.dark().colorScheme.primary,
                fontSize: 17,
                height: 22 / 17,
                fontWeight: FontWeight.w600,
                letterSpacing: -.43,
              ),
              child: widget.title ?? SizedBox.shrink(),
            ),
            DefaultTextStyle(
              style: TextStyle(
                color: ThemeData.dark().colorScheme.primary.withValues(alpha: .6),
                fontSize: 14,
                height: 1,
                fontWeight: FontWeight.w400,
                letterSpacing: -.43,
              ),
              child: widget.subtitle ?? SizedBox.shrink(),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: controller1,
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
              onPageChanged: (idx) => controller2.animateToItem(idx, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut),
              itemCount: widget.images.expand((e) => e).length,
              itemBuilder: (context, index) => FutureBuilder(
                future: getApplicationDocumentsDirectory(), // FIXME: what if somewhere else
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting || !snapshot.hasData || snapshot.data == null)
                    return const Center(child: CircularProgressIndicator.adaptive(backgroundColor: Colors.white));
                  return Hero(
                    tag: widget.images.expand((e) => e).toList()[index],
                    child: InteractiveViewer(
                      clipBehavior: Clip.none,
                      maxScale: 5,
                      child: Image.file(File('${snapshot.data!.path}/${widget.images.expand((e) => e).toList()[index]}')),
                    ),
                  );
                },
              ),
            ),
          ),
          FutureBuilder(
            future: getApplicationDocumentsDirectory(), // FIXME: what if somewhere else
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting || !snapshot.hasData || snapshot.data == null)
                return SizedBox(height: 52 + MediaQuery.of(context).padding.bottom);
              return Padding(
                padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
                child: SizedBox(
                  height: 52,
                  child: ImageWheel(
                    controller: controller2,
                    onSelectedItemChanged: (idx) => controller1.animateToPage(idx, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut),
                    children:
                        widget.images.map((s) => s.map((e) => Image.file(File('${snapshot.data!.path}/$e'), alignment: Alignment.center, fit: BoxFit.cover)).toList()).toList(),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
