extension MapExtensions<K, V> on Map<K, V> {
  /// Removes all entries whose values are `null` or empty iterables.
  Map<K, V> toValidMap() {
    return Map.fromEntries(
      entries.where((e) {
        final value = e.value;

        if (value == null) return false;
        if (value is Iterable) {
          return value.isNotEmpty;
        }
        return true;
      }),
    );
  }
}

extension StringExtensions on String {
  List<String> splitFirst(String separator) {
    final index = indexOf(separator);
    if (index == -1) return [this];

    return [substring(0, index), substring(index + 1)];
  }
}
