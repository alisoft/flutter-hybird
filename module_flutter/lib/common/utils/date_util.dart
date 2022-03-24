
/// date utils
class DateUtil {
  static String processDateTime(String dateStr) {
    var now = DateTime.now();
    var moonLanding = DateTime.parse(dateStr);
    var difference = now.difference(moonLanding);
    if(difference.inSeconds < 60) {
      return '${difference.inSeconds} seconds ago';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hours ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else if ((difference.inDays ~/ 7) < 2) {
      return '${(difference.inDays ~/ 7)} week ago';
    } else if (difference.inDays < 30) {
      return '${difference.inDays} days ago';
    } else {
      return dateStr.substring(0, 10);
    }
  }
}