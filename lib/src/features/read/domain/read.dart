// TODO Implement this library.

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

typedef KeepID = String;

class Read extends Equatable{

  const Read({required this.date});
  final date;

  @override
  // TODO: implement props
  List<Object?> get props => date;

  

}