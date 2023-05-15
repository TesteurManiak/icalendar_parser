extension MapExtensions<K, V> on Map<K, V> {
  /// Removes all entries whose values are `null` or empty iterables.
  Map<K, V> toValidMap() {
    return Map.fromEntries(
      entries.where((e) {
        final value = e.value;
        return switch (value) {
          null => false,
          Iterable() when value.isEmpty => false,
          String() when value.isEmpty => false,
          _ => true,
        };
      }),
    );
  }
}

extension MapParamsExtension on Map<String, String> {
  /// Concatenate the parameters to a string, each separated by a ";".
  String concatenateParams() {
    return entries.map((e) => '${e.key}=${e.value}').join(';');
  }
}

extension StringExtensions on String {
  List<String> splitFirst(String separator) {
    final index = indexOf(separator);
    if (index == -1) return [this];

    return [substring(0, index), substring(index + 1)];
  }

  List<String> splitLast(String separator) {
    final index = lastIndexOf(separator);
    if (index == -1) return [this];

    return [substring(0, index), substring(index + 1)];
  }
}
