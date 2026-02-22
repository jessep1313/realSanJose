import 'package:go_router/go_router.dart';
import 'package:real_san_jose/model/schedule.dart';
import 'package:real_san_jose/view/addbankaccount/bankaccountscreen.dart';
import 'package:real_san_jose/view/callscreen/callscreen.dart';
import 'package:real_san_jose/view/chatdetails/chatdetailscreen.dart';
import 'package:real_san_jose/view/consulthistory/consulthistoryscreen.dart';
import 'package:real_san_jose/view/dashboard/dashboardscreen.dart';
import 'package:real_san_jose/view/details/detailscreen.dart';
import 'package:real_san_jose/view/editprofile/editprofilescreen.dart';
import 'package:real_san_jose/view/forgotpassword/forgotpasswordscreen.dart';
import 'package:real_san_jose/view/login/loginscreen.dart';
import 'package:real_san_jose/view/notification/notificationscreen.dart';
import 'package:real_san_jose/view/onboarding/onboardingscreen.dart';
import 'package:real_san_jose/view/patient/patientscreen.dart';
import 'package:real_san_jose/view/patientdetail/patientdetailscreen.dart';
import 'package:real_san_jose/view/report/reportscreen.dart';
import 'package:real_san_jose/view/servicemanagment/servicemanagementscreen.dart';
import 'package:real_san_jose/view/servicemanagment/widget/availabletimeselect.dart';
import 'package:real_san_jose/view/splash/splashscreen.dart';

import '../view/register/register.dart';

final GoRouter router = GoRouter(routes: [
  GoRoute(
    path: SplashScreen.routeName,
    builder: (context, state) => const SplashScreen(),
  ),
  GoRoute(
    path: OnboardingScreen.routeName,
    builder: (context, state) => OnboardingScreen(),
  ),
  GoRoute(
    path: LoginScreen.routeName,
    builder: (context, state) => LoginScreen(),
  ),
  GoRoute(
    path: RegisterScreen.routeName,
    builder: (context, state) => RegisterScreen(),
  ),
  GoRoute(
    path: ForgotPasswordScreen.routeName,
    builder: (context, state) => ForgotPasswordScreen(),
  ),
  GoRoute(
    path: DashboardScreen.routeName,
    builder: (context, state) => const DashboardScreen(),
  ),
  GoRoute(
    path: ReportScreen.routeName,
    builder: (context, state) => ReportScreen(),
  ),
  GoRoute(
    path: ConsultHistoryScreen.routeName,
    builder: (context, state) => ConsultHistoryScreen(),
  ),
  GoRoute(
    path: PatientScreen.routeName,
    builder: (context, state) => PatientScreen(),
  ),
  GoRoute(
    path: CallScreen.routeName,
    builder: (context, state) => const CallScreen(),
  ),
  GoRoute(
    path: ChatDetailScreen.routeName,
    builder: (context, state) => const ChatDetailScreen(),
  ),
  GoRoute(
    path: PatientDetailsScreen.routeName,
    builder: (context, state) => PatientDetailsScreen(),
  ),
  GoRoute(
    path: NotificationScreen.routeName,
    builder: (context, state) => const NotificationScreen(),
  ),
  GoRoute(
    path: BankAccountScreen.routeName,
    builder: (context, state) => BankAccountScreen(),
  ),
  GoRoute(
    path: EditProfileScreen.routeName,
    builder: (context, state) => EditProfileScreen(),
  ),
  GoRoute(
    path: ServiceManagementScreen.routeName,
    builder: (context, state) => ServiceManagementScreen(),
  ),
  GoRoute(
    path: AvailabletimeselectScreen.routeName,
    builder: (context, state) => AvailabletimeselectScreen(state.extra as int,),
  ),
  GoRoute(
    path: DetailsScreen.routeName,
    builder: (context, state) => DetailsScreen(
      schedule: state.extra as Schedule,
    ),
  ),
]);
