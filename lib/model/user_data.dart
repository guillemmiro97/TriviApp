
class UserData {
  final String username;
  final String countryCode;
  final int score;

  UserData({
    required this.username,
    required this.countryCode,
    required this.score,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      username: json['username'],
      countryCode: json['countryCode'],
      score: json['score'],
    );
  }
}