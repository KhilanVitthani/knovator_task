import 'package:knovator_task/database/db_helper.dart';

import '../main.dart';
import '../utilities/progress_dialog_utils.dart';

void setUp() {
  getIt.registerSingleton<CustomDialogs>(CustomDialogs());
  getIt.registerSingleton<DBHelper>(DBHelper());
}
