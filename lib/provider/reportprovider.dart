import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final reportProvider = ChangeNotifierProvider(
  (ref) => ReportProvider(),
);

class ReportProvider with ChangeNotifier {

}
