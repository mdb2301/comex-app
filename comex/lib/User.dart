class CustomUser {
//  TODO: Change username to two fields: firstName & lastName
  final String username, email;
  final DateTime dateJoined;
  final String firebaseId;
  bool profileUpdated;

  CustomUser({
        this.username,
        this.email,
        this.dateJoined,
        this.firebaseId,
        this.profileUpdated
  });

//  This allows us to create a user object straight from JSON
//  TODO: Change username to firstName and lastName
  factory CustomUser.fromJson(Map<String, dynamic> json) {
    return CustomUser(
      username: json['first_name'] + ' ' + json['last_name'],
      email: json['email'],
      firebaseId: json['firebase_id'],
      profileUpdated: json['profile_updated']
    );
  }
}
