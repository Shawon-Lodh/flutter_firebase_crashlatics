/*
    Created by Shawon Lodh on 07 January 2022
*/

import 'package:flutter/material.dart';

class MandatoryElementsUtil {

  static MandatoryElementsUtil instance = MandatoryElementsUtil();

  ///Mandatory needed for apps
  ///1. Perform Widgets Binding
  initializingWidgetsFlutterBinding(){
    return WidgetsFlutterBinding.ensureInitialized();
  }

}
