import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

typedef JobID = String;

@immutable
class Job extends Equatable {
  const Job({required this.id, required this.book, required this.page});
  final JobID id;
  final String book;
  final int page;

  @override
  List<Object> get props => [book, page];

  @override
  bool get stringify => true;

  factory Job.fromMap(Map<String, dynamic> data, String id) {
    final book = data['book'] as String;
    final page = data['page'] as int;
    final proclaimId = data['id'] as String;

    return Job(
      id: proclaimId,
      book: book,
      page: page,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'book': book,
      'page': page,
    };
  }
}

// class Job extends Equatable {
//   const Job({required this.id, required this.name, required this.page});
//   final JobID id;
//   final String name;
//   final int page;

//   @override
//   List<Object> get props => [name, page];

//   @override
//   bool get stringify => true;

//   factory Job.fromMap(Map<String, dynamic> data, String id) {
//     final name = data['name'] as String;
//     final page = data['page'] as int;
//     return Job(
//       id: id,
//       name: name,
//       page: page,
//     );
//   }

//   Map<String, dynamic> toMap() {
//     return {
//       'name': name,
//       'page': page,
//     };
//   }
// }

typedef ProclaimID = String;

@immutable
class Proclaim extends Equatable {
  const Proclaim({required this.id, required this.book, required this.page});
  final ProclaimID id;
  final String book;
  final int page;

  @override
  List<Object> get props => [book, page];

  @override
  bool get stringify => true;

  factory Proclaim.fromMap(Map<String, dynamic> data, String id) {
    final book = data['book'] as String;
    final page = data['page'] as int;
    return Proclaim(
      id: id,
      book: book,
      page: page,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'book': book,
      'page': page,
    };
  }
}
