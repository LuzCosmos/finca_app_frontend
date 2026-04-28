import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkService {
  Future<bool> hasNetwork() async {
    final results = await Connectivity().checkConnectivity();
    return results.any((r) => r != ConnectivityResult.none);
  }
}
