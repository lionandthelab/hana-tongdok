import 'package:flutter_test/flutter_test.dart';
import 'package:starter_architecture_flutter_firebase/src/features/jobs/domain/job.dart';

void main() {
  group('fromMap', () {
    test('job with all properties', () {
      final job = Job.fromMap(const {
        'name': 'Blogging',
        'page': 10,
      }, 'abc');
      expect(job, const Job(name: 'Blogging', page: 10, id: 'abc'));
    });

    test('missing name', () {
      // * If the 'name' is missing, this error will be emitted:
      // * _CastError:<type 'Null' is not a subtype of type 'String' in type cast>
      // * We can detect it by expecting that the test throws a TypeError
      expect(
          () => Job.fromMap(const {
                'page': 10,
              }, 'abc'),
          throwsA(isInstanceOf<TypeError>()));
    });
  });

  group('toMap', () {
    test('valid name, page', () {
      const job = Job(name: 'Blogging', page: 10, id: 'abc');
      expect(job.toMap(), {
        'name': 'Blogging',
        'page': 10,
      });
    });
  });

  group('equality', () {
    test('different properties, equality returns false', () {
      const job1 = Job(name: 'Blogging', page: 10, id: 'abc');
      const job2 = Job(name: 'Blogging', page: 5, id: 'abc');
      expect(job1 == job2, false);
    });
    test('same properties, equality returns true', () {
      const job1 = Job(name: 'Blogging', page: 10, id: 'abc');
      const job2 = Job(name: 'Blogging', page: 10, id: 'abc');
      expect(job1 == job2, true);
    });
  });
}
