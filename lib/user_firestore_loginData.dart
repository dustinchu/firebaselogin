import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import 'package:uuid/uuid_util.dart';

class DeviceAuthenticate {
  Future<bool> check(String email, String deviceID) async {
    final UserFirebaseStoreLoginData _userFirebaseStoreLoginData =
        UserFirebaseStoreLoginData();

    final String isCheckDeviceID =
        await _userFirebaseStoreLoginData.checkDeviceID(email, deviceID);
    bool result = true;
    switch (isCheckDeviceID) {
      //設備ID一樣
      case "true":
        result = true;
        break;
      //設備不一樣
      case "false":
        final bool isUpdateDeviceID =
            await _userFirebaseStoreLoginData.updateDeviceID(deviceID);
        if (isUpdateDeviceID)
          result = true;
        else
          result = false;
        break;
      //找不到資料
      case "error":
        final bool isInsertUserDate =
            await _userFirebaseStoreLoginData.insertUserData(email, deviceID);
        if (isInsertUserDate)
          result = true;
        else
          result = false;
    }
    return result;
  }
}

class UserFirebaseStoreLoginData {
  var uuid = new Uuid();

  Future<String> checkDeviceID(String email, String deviceID) async {
    try {
      var result = await Firestore.instance
          .collection('user')
          .document(email)
          .get()
          .then((documentSnapshot) {
        return documentSnapshot.data['deviceID'].toString() == deviceID;
      });
      print("device result = ${deviceID} ====${result} ");
      return result.toString();
    } catch (e) {
      print('getDeviceID Query Error');
      return "error";
    }
  }

  Future<bool> insertUserData(String email, String deviceID) async {
    try {
      var now = new DateTime.now();
      uuid.v4();
      bool result =
          await Firestore.instance.collection('user').document(email).setData({
        'deviceID': deviceID,
        'group': uuid.v4(options: {'rng': UuidUtil.cryptoRNG}),
        'dateTime': now.toString()
      }).then((documentSnapshot) {
        print('insertUserData successful');
        return true;
      });
      return result;
    } catch (e) {
      print('insertUserData error' + e);
      return false;
    }
  }

  Future<bool> updateDeviceID(String deviceID) async {
    try {
      bool result = await Firestore.instance
          .collection('bandnames')
          .document('email')
          .updateData({'deviceID': deviceID}).then((documentSnapshot) {
        print('updateDeviceID successful');
        return true;
      });
      return result;
    } catch (e) {
      print('updateDeviceID error');
      return false;
    }
  }
}
