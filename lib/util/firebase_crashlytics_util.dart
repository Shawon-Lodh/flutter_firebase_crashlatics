/*
    Created by Shawon Lodh on 07 January 2022
*/

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class FirebaseCrashlyticsUtil {

  // Crash Reports are added to Crashlytics on next time App Opening after Crash

  static FirebaseCrashlyticsUtil instance = FirebaseCrashlyticsUtil();

  ///Mandatory needed for any firebase operation
  ///1. Start FireBase Operation
  startFireBaseOperation()async{
    await Firebase.initializeApp();
  }

  ///0. Enable Crashlytics Collection
  Future initializeFirebaseCrashlytics({bool? testCrashlytics}) async{

    testCrashlytics ??= false;

    if (testCrashlytics) {
      // Force enable crashlytics collection enabled if we're testing it.
      await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
    } else {
      // Else only enable it in non-debug builds.
      // You could additionally extend this to allow users to opt-in.
      await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(!kDebugMode);
    }

  }

  ///1. Create a Crash by force
  //You don't have to wait for a crash to know that Crashlytics is working. To force a crash, call the crash method:
  createForceCrash(){
    FirebaseCrashlytics.instance.crash();
  }
  ///2. Create Fatal crash
  //If you would like to record a fatal error, you may pass in a fatal argument as true. The crash report will appear in your Crashlytics dashboard with the event type Crash, the event summary stack trace will also be referenced as a Fatal Exception.
  Future createFatalCrash({required Object error, required StackTrace stackTrace, required String errorReason})async{
    await FirebaseCrashlytics.instance.recordError(
        error,
        stackTrace,
        reason: errorReason,
        // Pass in 'fatal' argument
        fatal: true
    );
  }

  ///3. Create Non-Fatal crash
  //By default non-fatal errors are recorded. The crash report will appear in your Crashlytics dashboard with the event type Non-fatal, the event summary stack trace will also be referenced as a Non-fatal Exception.
  Future createNonFatalCrash({required Object error, required StackTrace stackTrace, required String errorReason})async{
    await FirebaseCrashlytics.instance.recordError(
        error,
        stackTrace,
        reason: errorReason
    );
  }

  ///4. Create Custom Keys
  //To associate key/value pairs with your crash reports, you can use the setCustomKey method
  createCustomKeys({required String key,required dynamic value,}){
    FirebaseCrashlytics.instance.setCustomKey(key, value);
  }

  ///5. Create Custom log messages
  //To add custom Crashlytics log messages to your app, use the log method
  createCustomLogMessages({required String logMessage}){
    FirebaseCrashlytics.instance.log(logMessage);
  }

  ///6. Set user identifiers
  //To add user IDs to your reports, assign each user with a unique ID. This can be an ID number, token or hashed value
  setUserIdentifiers({required String userIdentifier}){
    FirebaseCrashlytics.instance.setUserIdentifier(userIdentifier);
  }
  ///7. Handling uncaught errors
  //By overriding FlutterError.onError with FirebaseCrashlytics.instance.recordFlutterError, it will automatically catch all errors that are thrown within the Flutter framework.
  handlingUncaughtErrors(){
    Function originalOnError = FlutterError.onError as Function;
    FlutterError.onError = (FlutterErrorDetails errorDetails) async {
      await FirebaseCrashlytics.instance.recordFlutterError(errorDetails);
      originalOnError(errorDetails);
    };
  }

  ///8. Handling Zoned Errors(Best practice for Button on press error listening)
  //Not all errors are caught by Flutter. Sometimes, errors are instead caught by Zones. A common case were FlutterError would not be enough is when an exception happen inside the onPressed of a button:
  handlingZonedErrors({required Object error, required StackTrace stackTrace}){
    FirebaseCrashlytics.instance.recordError(error, stackTrace);
  }

}
