import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_option_prod.dart';
import 'flavors.dart';
import 'main.dart' as runner;

Future<void> main() async {
  F.appFlavor = Flavor.prod;
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: DefaultProdFirebaseOptions.currentPlatform);
  await runner.main();
}
