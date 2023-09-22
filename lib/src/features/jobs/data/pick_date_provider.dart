import 'package:flutter/material.dart';
import 'dart:convert';
class PickDate with ChangeNotifier {
  DateTime _pickDate = DateTime.now();

  DateTime get pickDate => _pickDate;

  void pick(date) {
    _pickDate = date;
    notifyListeners();
  }
}

