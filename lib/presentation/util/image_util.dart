class ImageUtil {
  static String parseWithSize(String url, int size) {
    final split = url.split('.');
    final ext = split.last;
    final prefix = split.sublist(0, split.length - 1).join('.');
    return '${prefix}_$size.$ext';
  }

  static String parse256(String url) => parseWithSize(url, 256);

  static String parse600(String url) => parseWithSize(url, 600);
}
