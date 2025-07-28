import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:voice_task/configs/routes/route.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:voice_task/features/landing/models/user_model.dart';

import 'configs/localizations/localization_string.dart';
import 'features/note/sub_features/add_note/models/note_model.dart';
import 'features/task/models/task_model.dart';
import 'firebase_options.dart';

import 'configs/pages/page.dart';
import 'configs/themes/theme.dart';
import 'shared/bindings/global_binding.dart';
import 'utils/services/hive_service.dart';
import 'utils/services/notification_service.dart';
import 'utils/services/sentry_services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final appDocumentDir = await getApplicationDocumentsDirectory();
  await Hive.initFlutter(appDocumentDir.path);
  Hive.registerAdapter(NoteAdapter());
  Hive.registerAdapter(TaskAdapter());
  Hive.registerAdapter(TaskStatusAdapter());
  Hive.registerAdapter(TaskPriorityAdapter());
  Hive.registerAdapter(UserModelAdapter());
  await Hive.openBox("voice_task");
  await Hive.openBox<Note>('notes');
  await Hive.openBox<Map>('pending_notes_sync'); 
  await Hive.openBox<Task>('tasks');
  await Hive.openBox<Map>('pending_task_sync');
  await Hive.openBox<TaskStatus>('taskStatus');
  await Hive.openBox<TaskPriority>('taskPriority');
  await Hive.openBox<UserModel>('userProfile');

  await Get.putAsync(() async {
    final service = LocalStorageService();
    return await service.init();
  });

  await NotificationService().init();
  await NotificationService().requestPermissions();
  await dotenv.load(fileName: ".env");

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
    authOptions: FlutterAuthClientOptions(
      detectSessionInUri: false,
    ),
  );

  await SentryFlutter.init(
    (options) {
      options.dsn = dotenv.env['SENTRY_DSN']!;
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
