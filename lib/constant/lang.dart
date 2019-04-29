class LangCode {
  static const String GERMAN = 'de';
  static const String KOREAN = 'ko';

  static final Map _langLabels = {
    KOREAN: 'Korean',
    GERMAN: 'German'
  };

  static String label(String code) => _langLabels[code];
}
