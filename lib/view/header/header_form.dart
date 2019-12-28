import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebaselogin/fontSizes.dart';
import 'package:firebaselogin/fontColors.dart';
import 'package:firebaselogin/bloc/index/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebaselogin/view/circular/circular.dart';
class Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<IndexBloc, IndexState>(
      builder: (context, state) {
        return GestureDetector(
          child: ClipPath(
            child: Container(
              width: double.infinity,
              height: ScreenUtil.getInstance().setHeight(500),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment(0.5, 1.0),
                  colors: [
                    Color.fromRGBO(239, 136, 118, 1),
                    Color.fromRGBO(238, 119, 149, 1)
                  ],
                ),
              ),
              child: Center(
                  child: Padding(
                padding: EdgeInsets.only(
                  top: ScreenUtil.getInstance().setHeight(70),
                ),
                child: Column(
                  children: <Widget>[
                    Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(" 藍芽 ",
                              style: TextStyle(
                                  fontSize: selectedFontSize(0, state.isIndex),
                                  color: selectedFontColor(0, state.isIndex))),
                          Text(" 首頁 ",
                              style: TextStyle(
                                  fontSize: selectedFontSize(1, state.isIndex),
                                  color: selectedFontColor(1, state.isIndex))),
                          Text(" 設定 ",
                              style: TextStyle(
                                  fontSize: selectedFontSize(2, state.isIndex),
                                  color: selectedFontColor(2, state.isIndex))),
                          Text(" 關於 ",
                              style: TextStyle(
                                  fontSize: selectedFontSize(3, state.isIndex),
                                  color: selectedFontColor(3, state.isIndex))),
                        ],
                      ),
                    ),
                    Container(
                      child: Row(
                        //mainAxisSize 壓縮或伸長元件的間距
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IndexCircular(
                              color: selectedFontColor(0, state.isIndex)),
                          IndexCircular(
                              color: selectedFontColor(1, state.isIndex)),
                          IndexCircular(
                              color: selectedFontColor(2, state.isIndex)),
                          IndexCircular(
                              color: selectedFontColor(3, state.isIndex)),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          top: ScreenUtil.getInstance().setHeight(40)),
                      child: Text('${state.isIndex}',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: ScreenUtil.getInstance()
                                  .setSp(FontSize.totalSize),
                              color: FontColors.focusFontColor)),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          top: ScreenUtil.getInstance().setHeight(5)),
                      child: Text("今日總花費",
                          style: TextStyle(
//                              fontWeight: FontWeight.bold,
                              fontSize: ScreenUtil.getInstance()
                                  .setSp(FontSize.defaultFontSize),
                              color: FontColors.focusFontColor)),
                    )
                  ],
                ),
              )),
            ),
            clipper: BottomWaveClipper(),
          ),
        );
      },
    );
  }
}

//底部裁切
class BottomWaveClipper extends CustomClipper<Path> {
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height);
    path.quadraticBezierTo(
        size.width / 2, size.height - 100, size.width, size.height);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

//字體焦點顏色
dynamic selectedFontColor(int index, int selectedIndex) {
  var fontColor = FontColors.defaultFontColor;
  switch (index) {
    case 0:
      selectedIndex == 0
          ? fontColor = FontColors.focusFontColor
          : fontColor = FontColors.defaultFontColor;
      break;
    case 1:
      selectedIndex == 1
          ? fontColor = FontColors.focusFontColor
          : fontColor = FontColors.defaultFontColor;
      break;

    case 2:
      selectedIndex == 2
          ? fontColor = FontColors.focusFontColor
          : fontColor = FontColors.defaultFontColor;
      break;

    case 3:
      selectedIndex == 3
          ? fontColor = FontColors.focusFontColor
          : fontColor = FontColors.defaultFontColor;
      break;
  }
  return fontColor;
}

//字體焦點大小
dynamic selectedFontSize(int index, int selectedIndex) {
  var fonSize = ScreenUtil.getInstance().setSp(FontSize.defaultFontSize);
  switch (index) {
    case 0:
      selectedIndex == 0
          ? fonSize = ScreenUtil.getInstance().setSp(FontSize.focusFontSize)
          : fonSize = ScreenUtil.getInstance().setSp(FontSize.defaultFontSize);
      break;
    case 1:
      selectedIndex == 1
          ? fonSize = ScreenUtil.getInstance().setSp(FontSize.focusFontSize)
          : fonSize = ScreenUtil.getInstance().setSp(FontSize.defaultFontSize);
      break;

    case 2:
      selectedIndex == 2
          ? fonSize = ScreenUtil.getInstance().setSp(FontSize.focusFontSize)
          : fonSize = ScreenUtil.getInstance().setSp(FontSize.defaultFontSize);
      break;

    case 3:
      selectedIndex == 3
          ? fonSize = ScreenUtil.getInstance().setSp(FontSize.focusFontSize)
          : fonSize = ScreenUtil.getInstance().setSp(FontSize.defaultFontSize);
      break;
  }

  return fonSize;
}