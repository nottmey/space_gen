import 'package:optional_status_code/api.dart';

class Optional {
  Optional({ApiClient? client}) : client = client ?? ApiClient();

  final ApiClient client;

  DefaultApi get defaultApi => DefaultApi(client);
}
