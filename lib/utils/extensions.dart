part of utils;

extension PagingExtension on int? {
  int offset(int? limit) =>
      (this ?? 1) * (limit ?? 20) -
      (limit ?? 20);

  int get limit => this ?? 20;
}

extension CapExtension on String {
  String get inCaps =>
      length > 0 ? '${this[0].toUpperCase()}${substring(1)}' : '';

  String allInCaps({bool isAll = true}) => isAll ? toUpperCase() : this;

  String get capitalizeFirstOfEach => replaceAll(RegExp(' +'), ' ')
      .split(' ')
      .map((str) => str.inCaps)
      .join(' ');
}

extension StringExtensions on String {
  bool get hasOnlyWhitespaces => trim().isEmpty && isNotEmpty;

  bool get isEmptyOrNull {
    return isEmpty;
  }

  String toSpaceSeparated() {
    final value =
        replaceAllMapped(RegExp(r'.{4}'), (match) => '${match.group(0)} ');
    return value;
  }

  String formatCopy() {
    return replaceAll('},', '\n},\n')
        .replaceAll('[{', '[\n{\n')
        .replaceAll(',"', ',\n"')
        .replaceAll('{"', '{\n"')
        .replaceAll('}]', '\n}\n]');
  }

  bool get isNoInternetError => contains('SocketException: Failed host lookup');

  bool get isURLImage =>
      (isNotEmpty) && (contains('http') || contains('https'));
}

extension ScaleSizeExtension on BuildContext {
  double scaleWith(double ratioWidthHeight) {
    return ratioWidthHeight * MediaQuery.sizeOf(this).height;
  }

  double scaleHeight(double ratioWidthHeight) {
    return MediaQuery.sizeOf(this).width / ratioWidthHeight;
  }
}
