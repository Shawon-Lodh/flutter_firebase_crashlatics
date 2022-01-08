import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_crashlatics/pages/default_crashlatics_sample.dart';
import 'package:flutter_firebase_crashlatics/util/firebase_crashlytics_util.dart';
import 'package:flutter_firebase_crashlatics/util/mandatory_elements_util.dart';


Future<void> main() async {
  /// for flutter Crashlytics fetch all specific errors must use run zone guarded
  await runZonedGuarded(() async {
    MandatoryElementsUtil.instance.initializingWidgetsFlutterBinding();
    await Firebase.initializeApp();
    FirebaseCrashlyticsUtil.instance.handlingUncaughtErrors();
    runApp(MyApp());
  }, (error, stackTrace) {
    FirebaseCrashlyticsUtil.instance.handlingZonedErrors(error: error, stackTrace: stackTrace);
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: DefaultCrashlaticsSample(),
    );
  }
}