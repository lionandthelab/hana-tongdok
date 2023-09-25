class KeepSubmitException {
  String get title => '제목 오류';
  String get description => '노트 오류';

  @override
  String toString() {
    return '$title. $description.';
  }
}
