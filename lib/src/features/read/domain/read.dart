// TODO Implement this library.

import 'package:equatable/equatable.dart';


typedef KeepID = String;

class Dates extends Equatable{

  const Dates({required this.id,required this.date});
  final String date;
  final String id;

  @override
  // TODO: implement props
  List<Object?> get props => [date];


  @override
  bool get stringify => true;

  factory Dates.fromMap(Map<String, dynamic> data, String id) {
    final date = data['date'] as String;

    return Dates(
      id: id,
      date: date,
    );
  }

}