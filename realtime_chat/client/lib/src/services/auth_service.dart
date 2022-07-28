import 'package:get/get.dart';

import '../models/user.dart';

class AuthService extends GetxService {

  User? currentUser;

  bool get isUserAuthenticated => currentUser == null ? false : true;


}
