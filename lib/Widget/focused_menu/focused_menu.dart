library focused_menu;

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';

import 'modals.dart';

class FocusedMenuHolder extends StatefulWidget {
  final Widget child;
  final double menuItemExtent;
  final double menuWidth;
  final List<FocusedMenuItem> menuItems;
  final bool animateMenuItems;
  final BoxDecoration menuBoxDecoration;
  final Function onPressed;
  final Duration duration;
  final double blurSize;
  final Color? blurBackgroundColor;
  final double bottomOffsetHeight;
  final double menuOffset;
  /// Open with tap insted of long press.
  final bool openWithTap;
  final bool isUserMember;
  final bool isChatPage;
  final bool isLeftPadding;
  final bool isRightPadding;

  FocusedMenuHolder(
      {Key? key,
        required this.child,
        required this.onPressed,
        required this.menuItems,
      required this.duration,
      required this.menuBoxDecoration,
      required this.menuItemExtent,
      required this.animateMenuItems,
      required this.blurSize, this.blurBackgroundColor,
      required this.menuWidth,
      required this.bottomOffsetHeight,
      required this.menuOffset,
      this.openWithTap = false,
        this.isUserMember = true,
        this.isChatPage = false,
        this.isLeftPadding = false,
        this.isRightPadding = false,
      })
      : super(key: key);

  @override
  _FocusedMenuHolderState createState() => _FocusedMenuHolderState();
}

class _FocusedMenuHolderState extends State<FocusedMenuHolder> {
  GlobalKey containerKey = GlobalKey();
  Offset childOffset = Offset(0, 0);
  late Size childSize;

  getOffset(){
    RenderBox renderBox = containerKey.currentContext!.findRenderObject() as RenderBox;
    Size size = renderBox.size;
    Offset offset = renderBox.localToGlobal(Offset.zero);
    setState(() {
      this.childOffset = Offset(offset.dx, offset.dy);
      childSize = size;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        key: containerKey,
        onTap: () async {
          widget.onPressed();
          if (widget.openWithTap) {
            await openMenu(context);
          }
        },
        onLongPress: () async {
          if (!widget.openWithTap && widget.isUserMember) {
            ///Custom Vibrate added by me on 10th december 2022
            //HapticFeedback.selectionClick();
            Vibration.vibrate(
                pattern: [1, 150, 1, 150], intensities: [100, 100]
            );
            await openMenu(context);
          }
        },
        child: widget.child);
  }

  Future openMenu(BuildContext context) async {
    getOffset();
    await Navigator.push(
        context,
        PageRouteBuilder(
            transitionDuration: widget.duration ?? Duration(milliseconds: 100),
            pageBuilder: (context, animation, secondaryAnimation) {
              animation = Tween(begin: 0.0, end: 1.0).animate(animation);
              return FadeTransition(
                  opacity: animation,
                  child: widget.isChatPage?
                  FocusedMenuDetailsForChat(
                    itemExtent: widget.menuItemExtent,
                    menuBoxDecoration: widget.menuBoxDecoration,
                    child: widget.child,
                    childOffset: childOffset,
                    childSize: childSize,
                    menuItems: widget.menuItems,
                    blurSize: widget.blurSize,
                    menuWidth: widget.menuWidth,
                    blurBackgroundColor: widget.blurBackgroundColor,
                    animateMenu: widget.animateMenuItems ?? true,
                    bottomOffsetHeight: widget.bottomOffsetHeight ?? 0,
                    menuOffset: widget.menuOffset ?? 0,
                    isLeftPadding: widget.isLeftPadding,
                    isRightPadding: widget.isRightPadding,
                  ):
                  FocusedMenuDetails(
                    itemExtent: widget.menuItemExtent,
                    menuBoxDecoration: widget.menuBoxDecoration,
                    child: widget.child,
                    childOffset: childOffset,
                    childSize: childSize,
                    menuItems: widget.menuItems,
                    blurSize: widget.blurSize,
                    menuWidth: widget.menuWidth,
                    blurBackgroundColor: widget.blurBackgroundColor!,
                    animateMenu: widget.animateMenuItems ?? true,
                    bottomOffsetHeight: widget.bottomOffsetHeight ?? 0,
                    menuOffset: widget.menuOffset ?? 0,
                  ));
            },
            fullscreenDialog: true,
            opaque: false));
  }
}

class FocusedMenuDetails extends StatelessWidget {
  final List<FocusedMenuItem> menuItems;
  final BoxDecoration menuBoxDecoration;
  final Offset childOffset;
  final double itemExtent;
  final Size childSize;
  final Widget child;
  final bool animateMenu;
  final double blurSize;
  final double menuWidth;
  final Color blurBackgroundColor;
  final double bottomOffsetHeight;
  final double menuOffset;

  const FocusedMenuDetails(
      {Key? key, required this.menuItems, required this.child, required this.childOffset, required this.childSize, required this.menuBoxDecoration, required this.itemExtent, required this.animateMenu, required this.blurSize, required this.blurBackgroundColor, required this.menuWidth, required this.bottomOffsetHeight, required this.menuOffset})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    final maxMenuHeight = size.height * 0.45;
    final listHeight = menuItems.length * (itemExtent ?? 50.0);

    final maxMenuWidth = menuWidth??(size.width * 0.70);
    final menuHeight = listHeight < maxMenuHeight ? listHeight : maxMenuHeight;
    final leftOffset = (childOffset.dx+maxMenuWidth ) < size.width ? childOffset.dx: (childOffset.dx-maxMenuWidth+childSize.width);
    final topOffset = (childOffset.dy + menuHeight + childSize.height) < size.height - bottomOffsetHeight ? childOffset.dy + childSize.height + menuOffset : childOffset.dy - menuHeight - menuOffset;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: blurSize??4, sigmaY: blurSize??4),
                  child: Container(
                    color: (blurBackgroundColor??Colors.black).withOpacity(0.7),
                  ),
                )),
            Positioned(
              top: topOffset,
              left: leftOffset,
              child: TweenAnimationBuilder(
                duration: Duration(milliseconds: 200),
                builder: (BuildContext context, double value, Widget? child) {
                  return Transform.scale(
                    scale: value,
                    alignment: Alignment.center,
                    child: child,
                  );
                },
                tween: Tween(begin: 0.0, end: 1.0),
                child: Container(
                  width: maxMenuWidth,
                  height: menuHeight,
                  decoration: menuBoxDecoration ??
                      BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                          boxShadow: [const BoxShadow(color: Colors.black38, blurRadius: 10, spreadRadius: 1)]),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                    child: ListView.builder(
                      itemCount: menuItems.length,
                      padding: EdgeInsets.zero,
                      physics: BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        FocusedMenuItem item = menuItems[index];
                        Widget listItem = GestureDetector(
                            onTap:
                                () {
                              Navigator.pop(context);
                              item.onPressed!();

                            },
                            child: Container(
                                alignment: Alignment.center,
                                margin: const EdgeInsets.only(bottom: 1),
                                color: item.backgroundColor ?? Colors.white,
                                height: itemExtent ?? 50.0,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 14),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      item.title!,
                                      if (item.trailingIcon != null) ...[item.trailingIcon!]
                                    ],
                                  ),
                                )));
                        if (animateMenu) {
                          return TweenAnimationBuilder(
                              builder: (context, dynamic value, child) {
                                return Transform(
                                  transform: Matrix4.rotationX(1.5708 * value),
                                  alignment: Alignment.bottomCenter,
                                  child: child,
                                );
                              },
                              tween: Tween(begin: 1.0, end: 0.0),
                              duration: Duration(milliseconds: index * 200),
                              child: listItem);
                        } else {
                          return listItem;
                        }
                      },
                    ),
                  ),
                ),
              ),
            ),
            Positioned(top: childOffset.dy, left: childOffset.dx, child: AbsorbPointer(absorbing: true, child: Container(
                width: childSize.width,
                height: childSize.height,
                child: child))),
          ],
        ),
      ),
    );
  }
}

class FocusedMenuDetailsForChat extends StatelessWidget {
  final List<FocusedMenuItem> menuItems;
  final BoxDecoration menuBoxDecoration;
  final Offset childOffset;
  final double itemExtent;
  final Size childSize;
  final Widget child;
  final bool animateMenu;
  final double blurSize;
  final double menuWidth;
  final Color? blurBackgroundColor;
  final double bottomOffsetHeight;
  final double menuOffset;
  final isLeftPadding;
  final isRightPadding;

  const FocusedMenuDetailsForChat(
      {Key? key, required this.menuItems, required this.child, required this.childOffset, required this.childSize, required this.menuBoxDecoration, required this.itemExtent, required this.animateMenu, required this.blurSize, this.blurBackgroundColor, required this.menuWidth, required this.bottomOffsetHeight, required this.menuOffset,this.isLeftPadding,this.isRightPadding})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    final maxMenuHeight = size.height * 0.45;
    final listHeight = menuItems.length * (itemExtent ?? 50.0);

    final maxMenuWidth = menuWidth??(size.width * 0.70);
    final menuHeight = listHeight < maxMenuHeight ? listHeight : maxMenuHeight;
    final leftOffset = (childOffset.dx+maxMenuWidth ) < size.width ? childOffset.dx: (childOffset.dx-maxMenuWidth+childSize.width);
    final topOffset = (childOffset.dy + menuHeight + childSize.height) < size.height - bottomOffsetHeight ? childOffset.dy + childSize.height + menuOffset : childOffset.dy - menuHeight - menuOffset;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: blurSize??4, sigmaY: blurSize??4),
                  child: Container(
                    color: (blurBackgroundColor??Colors.black).withOpacity(0.7),
                  ),
                )),
            Positioned(
              top: topOffset -80,
              left: leftOffset,
              child: TweenAnimationBuilder(
                duration: Duration(milliseconds: 200),
                builder: (BuildContext context, double value, Widget? child) {
                  return Transform.scale(
                    scale: value,
                    alignment: Alignment.center,
                    child: child,
                  );
                },
                tween: Tween(begin: 0.0, end: 1.0),
                child: Container(
                  width: maxMenuWidth,
                  height: menuHeight + childSize.height + 45,
                  decoration: menuBoxDecoration ??
                      BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                          boxShadow: [const BoxShadow(color: Colors.black38, blurRadius: 10, spreadRadius: 1)]),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                    child: ListView.builder(
                      itemCount: menuItems.length,
                      padding: EdgeInsets.zero,
                      physics: BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        if(index==1){
                          return AbsorbPointer(absorbing: true, child: Container(
                              margin: EdgeInsets.only(top: 10,bottom: 15),
                              width: childSize.width,
                              //height: childSize.height,
                              child: child),
                          );
                        }else{
                          FocusedMenuItem item = menuItems[index];
                          Widget listItem = GestureDetector(
                              onTap:
                                  () {
                                Navigator.pop(context);
                                item.onPressed!();

                              },
                              child: Container(
                                  alignment: Alignment.center,
                                  margin: EdgeInsets.only(left: isLeftPadding?40:0,right: isRightPadding?40:0),
                                  //color: item.backgroundColor ?? Colors.white,
                                  height: index == 0? 70: itemExtent ?? 50.0,
                                  decoration: BoxDecoration(
                                    color: item.backgroundColor ?? Colors.white,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(index==0?35:index==2?20:index==menuItems.length-1?0:0),
                                      topRight: Radius.circular(index==0?35:index==2?20:index==menuItems.length-1?0:0),
                                      bottomLeft: Radius.circular(index==0?35:index==2?0:index==menuItems.length-1?20:0),
                                      bottomRight: Radius.circular(index==0?35:index==2?0:index==menuItems.length-1?20:0),
                                    ),//BorderRadius.circular(index==0?15:0),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 14),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        item.title!,
                                        if (item.trailingIcon != null) ...[item.trailingIcon!]
                                      ],
                                    ),
                                  )));
                          if (animateMenu) {
                            return TweenAnimationBuilder(
                                builder: (context, dynamic value, child) {
                                  return Transform(
                                    transform: Matrix4.rotationX(1.5708 * value),
                                    alignment: Alignment.bottomCenter,
                                    child: child,
                                  );
                                },
                                tween: Tween(begin: 1.0, end: 0.0),
                                duration: Duration(milliseconds: index * 200),
                                child: listItem);
                          } else {
                            return listItem;
                          }
                        }
                      },
                    ),
                  ),
                ),
              ),
            ),
            // Positioned(top: childOffset.dy, left: childOffset.dx, child: AbsorbPointer(absorbing: true, child: Container(
            //     width: childSize.width,
            //     height: childSize.height,
            //     child: child))),
          ],
        ),
      ),
    );
  }
}
