int calculateReadingTime(String content) {
  final wordCount = content.split(RegExp(r'\s+')).length;
  // speed = distanc/time
  // average speed of reading = 200 to 300 wpm
  final readingTime = wordCount / 230;

  // returining the reading time
  return readingTime.ceil();
}
