import 'package:connectivity_failures/api.dart';

class Connectivity {
  Connectivity({ApiClient? client}) : client = client ?? ApiClient();

  final ApiClient client;

  DefaultApi get defaultApi => DefaultApi(client);
}
