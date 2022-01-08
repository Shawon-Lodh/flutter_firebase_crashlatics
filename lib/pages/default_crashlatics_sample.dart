import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_crashlatics/util/firebase_crashlytics_util.dart';

class DefaultCrashlaticsSample extends StatefulWidget {
  const DefaultCrashlaticsSample({Key? key}) : super(key: key);

  @override
  State<DefaultCrashlaticsSample> createState() => _DefaultCrashlaticsSampleState();
}

class _DefaultCrashlaticsSampleState extends State<DefaultCrashlaticsSample> {
  late Future<void> _initializeFlutterFireFuture;

  @override
  void initState() {
    super.initState();
    print("Debug Mode : $kDebugMode");
    print("Profile Mode : $kProfileMode");
    print("Release Mode : $kReleaseMode");
    _initializeFlutterFireFuture = FirebaseCrashlyticsUtil.instance.initializeFirebaseCrashlytics(testCrashlytics: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crashlytics example app'),
      ),
      body: FutureBuilder(
        future: _initializeFlutterFireFuture,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              }
              return Center(
                child: Column(
                  children: <Widget>[
                    ElevatedButton(
                      onPressed: () {
                        // FirebaseCrashlytics.instance.setCustomKey('example', 'flutterfire');
                        FirebaseCrashlyticsUtil.instance.createCustomKeys(key: '${Random().nextInt(100)}', value: 'flutterfire');
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text(
                              'Custom Key "example: flutterfire" has been set \n'
                                  'Key will appear in Firebase Console once app has crashed and reopened'),
                          duration: Duration(seconds: 5),
                        ));
                      },
                      child: const Text('Key'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // FirebaseCrashlytics.instance
                        //     .log('This is a log example');
                        FirebaseCrashlyticsUtil.instance.createCustomLogMessages(logMessage: 'This is a log example');
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text(
                              'The message "This is a log example" has been logged \n'
                                  'Message will appear in Firebase Console once app has crashed and reopened'),
                          duration: Duration(seconds: 5),
                        ));
                      },
                      child: const Text('Log'),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text('App will crash is 5 seconds \n'
                              'Please reopen to send data to Crashlytics'),
                          duration: Duration(seconds: 5),
                        ));

                        // Delay crash for 5 seconds
                        sleep(const Duration(seconds: 5));

                        // Use FirebaseCrashlytics to throw an error. Use this for
                        // confirmation that errors are being correctly reported.
                        // FirebaseCrashlytics.instance.crash();
                        FirebaseCrashlyticsUtil.instance.createForceCrash();
                      },
                      child: const Text('Crash'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text('Thrown error has been caught \n'
                              'Please crash and reopen to send data to Crashlytics'),
                          duration: Duration(seconds: 5),
                        ));

                        // Example of thrown error, it will be caught and sent to
                        // Crashlytics.
                        throw StateError('Uncaught error thrown by app');
                      },
                      child: const Text('Throw Error'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text(
                              'Uncaught Exception that is handled by second parameter of runZonedGuarded \n'
                                  'Please crash and reopen to send data to Crashlytics'),
                          duration: Duration(seconds: 5),
                        ));

                        // Example of an exception that does not get caught
                        // by `FlutterError.onError` but is caught by
                        // `runZonedGuarded`.
                        runZonedGuarded(() {
                          Future<void>.delayed(const Duration(seconds: 2),
                                  () {
                                final List<int> list = <int>[];
                                print(list[100]);
                              });
                        }, (error, stackTrace) {
                          FirebaseCrashlyticsUtil.instance.handlingZonedErrors(error: error, stackTrace: stackTrace);
                        });
                      },
                      child: const Text('Async out of bounds'),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        try {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text('Recorded Error  \n'
                                'Please crash and reopen to send data to Crashlytics'),
                            duration: Duration(seconds: 5),
                          ));
                          throw Error();
                        } catch (e, s) {

                          // "reason" will append the word "thrown" in the
                          // Crashlytics console.
                          // await FirebaseCrashlytics.instance.recordError(e, s,
                          //     reason: 'as an example of fatal error',
                          //     fatal: true);

                          await FirebaseCrashlyticsUtil.instance.createFatalCrash(error: e, stackTrace: s, errorReason: 'as an example of fatal error');
                        }
                      },
                      child: const Text('Record Fatal Error'),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        try {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text('Recorded Error  \n'
                                'Please crash and reopen to send data to Crashlytics'),
                            duration: Duration(seconds: 5),
                          ));
                          throw Error();
                        } catch (e, s) {
                          // "reason" will append the word "thrown" in the
                          // Crashlytics console.
                          // await FirebaseCrashlytics.instance.recordError(e, s,
                          //     reason: 'as an example of non-fatal error');

                          await FirebaseCrashlyticsUtil.instance.createNonFatalCrash(error: e, stackTrace: s, errorReason: 'as an example of non-fatal error');

                        }
                      },
                      child: const Text('Record Non-Fatal Error'),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        try {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text('Recorded Error  \n'
                                'Please crash and reopen to send data to Crashlytics'),
                            duration: Duration(seconds: 5),
                          ));
                          throw Error();
                        } catch (e, s) {
                          // "reason" will append the word "thrown" in the
                          // Crashlytics console.
                          // await FirebaseCrashlytics.instance.recordError(e, s,
                          //     reason: 'as an example of non-fatal error');

                          FirebaseCrashlyticsUtil.instance.createNonFatalCrash(error: e, stackTrace: s, errorReason: 'as an example of non-fatal error');
                        }
                      },
                      child: const Text('Record Non-Fatal Error'),
                    ),
                  ],
                ),
              );
            default:
              return const Center(child: Text('Loading'));
          }
        },
      ),
    );
  }
}
