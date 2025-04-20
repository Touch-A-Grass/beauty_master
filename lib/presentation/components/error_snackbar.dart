import 'package:beauty_master/domain/models/app_error.dart';
import 'package:flutter/material.dart';

extension SnackbarExtension on BuildContext {
  void showErrorSnackBar(AppError error) {
    ScaffoldMessenger.of(this).showSnackBar(SnackBar(content: Text(error.message)));
  }
}
