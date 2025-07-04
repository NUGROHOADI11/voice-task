import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:hive_flutter/hive_flutter.dart';
// import 'package:isar/isar.dart';
// import 'package:path_provider/path_provider.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:voice_task/configs/routes/route.dart';
import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_app_check/firebase_app_check.dart';

import 'configs/localizations/localization_string.dart';
// import 'features/note/sub_features/add_note/models/isar_note.dart';
import 'firebase_options.dart';

import 'configs/pages/page.dart';
import 'configs/themes/theme.dart';
import 'shared/bindings/global_binding.dart';
// import 'utils/services/connectivity_service.dart';
import 'utils/services/hive_service.dart';
import 'utils/services/notification_service.dart';
import 'utils/services/sentry_services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService().init();
  await NotificationService().requestPermissions();
  await Hive.initFlutter();
  // Get.put(ConnectivityService());
  await Get.putAsync(() async {
    final service = LocalStorageService();
    return await service.init();
  });
  await Hive.openBox("voice_task");
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // final dir = await getApplicationDocumentsDirectory();
  // final isar = await Isar.open(
  //   [IsarNoteSchema],
  //   directory: dir.path,
  // );

  // await FirebaseAppCheck.instance.activate(
  //   webProvider: ReCaptchaV3Provider(
  //     dotenv.env['RECAPTCHA_SITE_KEY']!,
  //   ),
  //   androidProvider:
  //       kDebugMode ? AndroidProvider.debug : AndroidProvider.playIntegrity,
  //   appleProvider: kDebugMode ? AppleProvider.debug : AppleProvider.appAttest,
  // );

  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );

  await SentryFlutter.init(
    (options) {
      options.dsn =
          'https://265c9bdf1182f420c41a9e0571f8e0e1@o4508951422500864.ingest.us.sentry.io/4508951425056768';
      options.tracesSampleRate = 1.0;
      options.beforeSend = (event, hint) => filterSentryErrorBeforeSend(event);
    },
    appRunner: () => runApp(MyApp()),
  );
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final String? language = LocalStorageService.getLanguagePreference();

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(414, 896),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          title: 'Venturo Core',
          debugShowCheckedModeBanner: false,
          translations: LocalizationString(),
          locale: language != null ? Locale(language!) : Get.deviceLocale,
          fallbackLocale: const Locale('en', 'US'),
          supportedLocales: const [
            Locale('en', 'US'),
            Locale('id', 'ID'),
          ],
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            FlutterQuillLocalizations.delegate,
          ],
          initialBinding: GlobalBinding(),
          initialRoute: Routes.splashRoute,
          theme: themeLight,
          defaultTransition: Transition.native,
          getPages: Pages.pages,
        );
      },
    );
  }
}
