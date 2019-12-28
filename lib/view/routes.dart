import 'package:firebaselogin/view/pages/page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebaselogin/bloc/index/bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebaselogin/view/header/header.dart';

class Routes extends StatelessWidget {
  final String email;

  Routes({Key key, @required this.email}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //  需輸入在第一個頁面 設定手機尺寸 i6 iPhone6 750*1334
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);
    double touchX = 0;
    return BlocProvider(
      builder: (context) => IndexBloc()..dispatch(InitIndex()),
      child: BlocBuilder<IndexBloc, IndexState>(builder: (context, state) {
        return GestureDetector(
          child: Scaffold(
            body: Container(
              color: Color.fromRGBO(34, 31, 48, 1),
              child: Column(
                children: <Widget>[
                  Header(),
                  bodyWidget(state.isIndex),
                ],
              ),
            ),
          ),
          /*得到橫向觸摸的位置*/
          onHorizontalDragStart: (startDetails) {
            touchX = startDetails.globalPosition.dx;
          },
          /*得到觸摸結束後的位置 減掉結束位置來決定左滑右滑*/
          onHorizontalDragEnd: (endDetails) {
            if (endDetails.velocity.pixelsPerSecond.dx > touchX) {
              state.isIndex > 0
                  ? BlocProvider.of<IndexBloc>(context).dispatch(MinusIndex())
                  : state.isIndex;
            }else if (endDetails.velocity.pixelsPerSecond.dx < touchX) {
              if (endDetails.velocity.pixelsPerSecond.dx != 0.0) {
                state.isIndex < 3
                    ? BlocProvider.of<IndexBloc>(context).dispatch(AddIndex())
                    : state.isIndex;
              }
            }

          },
        );
      }),
    );
  }
}

Widget bodyWidget(int index) {
  var _widgetBody;
  switch (index) {
    case 0:
      _widgetBody = BluetoothBody();
      break;
    case 1:
      _widgetBody = HomeBody();
      break;
    case 2:
      _widgetBody = SettingBody();
      break;
    case 3:
      _widgetBody = AboutBody();
      break;
  }
  return _widgetBody;
}
