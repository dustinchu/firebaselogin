import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebaselogin/fontSizes.dart';
import 'package:firebaselogin/fontColors.dart';
import 'package:flutter_sparkline/flutter_sparkline.dart';

class SettingBody extends StatefulWidget {
  @override
  _SettingBodyState createState() => _SettingBodyState();
}

class _SettingBodyState extends State<SettingBody> {
  @override
  Widget build(BuildContext context) {
    var data = [0.0, 1.0, 1.5, 2.0, 0.0, 0.0, -0.5, -1.0, -0.5, 0.0, 0.0];

    return Container(
      child: Padding(
        padding: EdgeInsets.only(
            left: ScreenUtil.getInstance().setHeight(30),
            right: ScreenUtil.getInstance().setHeight(30),
            bottom: ScreenUtil.getInstance().setHeight(50)),
        child: Column(
          children: <Widget>[
            Text("+SettingBody ",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize:
                        ScreenUtil.getInstance().setSp(FontSize.focusFontSize),
                    color: FontColors.focusFontColor)),
            Padding(
              padding: EdgeInsets.only(
                top: ScreenUtil.getInstance().setHeight(40),
              ),
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Divider(
                      color: FontColors.defaultFontColor,
                      height: 6.0,
                    ),
                  ),
                  Text("Bank Accounts",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: ScreenUtil.getInstance()
                              .setSp(FontSize.defaultFontSize),
                          color: FontColors.defaultFontColor)),
                  Expanded(
                    flex: 1,
                    child: Divider(
                      color: FontColors.defaultFontColor,
                      height: 6.0,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: 3,
                  itemBuilder: (context, position) {


                    return Card(
                        color: Color.fromRGBO(0, 0, 0, 0.0),
                        //需設定0.0才會透明 不然listview有陰影
                        elevation: 0.0,
                        child: Container(
                          child: ListTile(
                            contentPadding:
                                EdgeInsets.symmetric(vertical: 10.0),
                            leading: Icon(Icons.home,
                                color: Colors.white, size: 30.0),
                            title: Row(
                              children: <Widget>[
                                Expanded(
                                  flex: 1,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text("房間",
                                          style: TextStyle(
                                              fontSize: ScreenUtil.getInstance()
                                                  .setSp(
                                                      FontSize.listTitle),
                                              color:
                                                  FontColors.focusFontColor)),
                                      Text("使用中",
                                          style: TextStyle(
                                              fontSize: ScreenUtil.getInstance()
                                                  .setSp(FontSize
                                                      .listSubtitle),
                                              color:
                                                  FontColors.defaultFontColor)),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text("費用",
                                          style: TextStyle(
                                              fontSize: ScreenUtil.getInstance()
                                                  .setSp(
                                                      FontSize.listTitle),
                                              color:
                                                  FontColors.focusFontColor)),
                                      Text("350",
                                          style: TextStyle(
                                              fontSize: ScreenUtil.getInstance()
                                                  .setSp(FontSize
                                                      .listSubtitle),
                                              color:
                                                  FontColors.defaultFontColor)),
                                    ],
                                  ),
                                ),
                                Expanded(
                                    flex: 1,
                                    child: new Sparkline(
                                      fallbackHeight: ScreenUtil.getInstance()
                                          .setHeight(50),
                                      lineColor:
                                          Color.fromRGBO(239, 136, 118, 1),
                                      data: data,
                                      fillMode: FillMode.below,
                                      fillGradient: new LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Color.fromRGBO(238, 119, 149, 1),
                                          Color.fromRGBO(239, 136, 118, 0.1)
                                        ],
                                      ),
                                    ))
                              ],
                            ),
                          ),
                          //底線
                          decoration: const BoxDecoration(
                            border: Border(
                              bottom:
                                  BorderSide(width: 1.0, color: Colors.white24),
                            ),
                            color: Color.fromRGBO(0, 0, 0, 0.0),
                          ),
                        ));
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
