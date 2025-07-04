import 'package:get/get.dart';

import 'en/en_us.dart';
import 'id/id_id.dart';

class LocalizationString extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': enUS,
        'id_ID': idID,
      };
}
