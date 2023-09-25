import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

typedef KeepID = String;

@immutable
class Keep extends Equatable {
  const Keep({required this.id, required this.title, required this.verse, required this.note});
  final KeepID id;
  final String title;
  final String verse;
  final String note;

  @override
  List<Object> get props => [title, verse, note];

  @override
  bool get stringify => true;

  factory Keep.fromMap(Map<String, dynamic> data, String id) {
    final title = data['title'] as String;
    final verse = data['verse'] as String;
    final note = data['note'] as String;
  
    return Keep(
      id: id,
      title: title,
      verse: verse,
      note: note,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id' : id,
      'title': title,
      'verse': verse,
      'note': note,
    };
  }
}