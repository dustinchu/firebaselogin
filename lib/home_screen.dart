import 'package:firebaselogin/user_firestore_loginData.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebaselogin/bloc/authentication_bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/index/bloc.dart';
import 'deviceID.dart';

Widget _build(BuildContext context) {
  return new StreamBuilder(
      stream: Firestore.instance
          .collection('bandnames')
          .document('doc')
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return new Text("Loading");
        }
        var userDocument = snapshot.data;
        return new Text(userDocument["name"]);
      });
}

class HomeScreen extends StatelessWidget {
  final String name;

  HomeScreen({Key key, @required this.name}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      builder: (context) => IndexBloc()..dispatch(InitIndex()),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Home'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: () {
                BlocProvider.of<AuthenticationBloc>(context).dispatch(
                  LoggedOut(),
                );
              },
            )
          ],
        ),
        body: BlocBuilder<IndexBloc,IndexState>(
          builder: (context,state) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Center(child: Text('Welcome $name!')),
                RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  onPressed: () async {
                    BlocProvider.of<IndexBloc>(context).dispatch(MinusIndex());
                  },
                  child: Text('minus'),
                ),
                RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  onPressed: ()  {
                    BlocProvider.of<IndexBloc>(context).dispatch(AddIndex());
                  },
                  child: Text('add'),
                ),
                Container(
                  child: _build(context),
                ),
                Container(
                  child: Text(state.isIndex.toString()),
                )
              ],
            );
          }
        ),
      ),
    );
  }
}
