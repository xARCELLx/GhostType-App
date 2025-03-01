import 'package:flutter/material.dart';
import 'package:ghost_type/custom_app/services/SignUpScreen_service.dart';

class AuthProvider with ChangeNotifier{
  bool _isLoading=false;
  String? _errorMessage=null;
  bool _isSingedUp=false;

  //getters
  bool get isLoading=>_isLoading;
  String? get errorMessages=>_errorMessage;
  bool get isSignedUp=>_isSingedUp;

  Future<void> SignUp({
    required String email,
    required String username,
    required String password
  }) async {
    _isLoading=true;
    _errorMessage=null;
    _isSingedUp=false;
    notifyListeners();

    try{
      final success = await SignUpService.signUp(
          email: email,
          username: username,
          password: password
      );
      _isSingedUp=true;
    }catch(e){
      _errorMessage=e.toString();
    }finally{
      _isLoading=false;
      notifyListeners();
    }

  }
  void clearError(){
    _errorMessage=null;
    notifyListeners();
  }
}