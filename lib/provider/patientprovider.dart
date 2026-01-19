import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swastha_doctor_flutter/model/patient.dart';
import 'package:swastha_doctor_flutter/model/schedule.dart';

final pateintProvider = ChangeNotifierProvider.autoDispose<PatientProvider>(
  (ref) => PatientProvider(),
);

class PatientProvider with ChangeNotifier {
  var patientList = [
    Patient('assets/images/specialist1.jpg', 'Ram Kumar Sharma', 'Male',
        "25 years old", "982476584"),
    Patient('assets/images/specialist2.jpg', 'Diwas Raut', 'Male',
        "18 years old", "982476584"),
    Patient('assets/images/specialist3.jpg', 'Devendra Aryal', 'Male',
        "20 years old", "982476584"),
    Patient('assets/images/specialist4.jpg', 'Roshan Aryal', 'Male',
        "23 years old", "982476584"),
    Patient('assets/images/specialist5.jpg', 'Rita Rimal', 'Female',
        "22 years old", "982476584"),
    Patient('assets/images/specialist6.jpg', 'Amita Giri', 'Female',
        "21 years old", "982476584"),
  ];
}
