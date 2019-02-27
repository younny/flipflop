class StringFormatter {
  static final String TAG_UNAVAILABLE = 'unavailable';
  static String formatMeaning(String source) {
    if(source == null || source.length == 0) return ': ' + TAG_UNAVAILABLE;
    return ': ' + source;
  }

  static String formatPronunciation(String source) {
    if(source == null || source.length == 0) return '[$TAG_UNAVAILABLE]';

    return '[$source]';
  }

  static String formatWord(String source) {
    if(source == null || source.length == 0) return TAG_UNAVAILABLE;

    return source;
  }
}
