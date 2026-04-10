import 'package:json_annotation/json_annotation.dart';
part 'personal_account.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class Phone {
  int? phoneType;
  String? phoneNumber;

  Phone({
    this.phoneType,
    this.phoneNumber,
  });

  factory Phone.fromJson(Map<String, dynamic> json) => _$PhoneFromJson(json);
  Map<String, dynamic> toJson() => _$PhoneToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class DeclineComment {
  String? comment;
  DateTime? updatedAt;

  DeclineComment({
    this.comment,
    this.updatedAt,
  });

  factory DeclineComment.fromJson(Map<String, dynamic> json) =>
      _$DeclineCommentFromJson(json);
  Map<String, dynamic> toJson() => _$DeclineCommentToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class Azure {
  String? login;
  bool? hasAzure;
  bool? hasOffice;

  Azure({
    this.login,
    this.hasAzure,
    this.hasOffice,
  });

  factory Azure.fromJson(Map<String, dynamic> json) => _$AzureFromJson(json);
  Map<String, dynamic> toJson() => _$AzureToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class PersonalAccount {
  int? id;
  String? fulName;
  String? address;
  String? dateBirth;
  String? study;
  String? email;
  int? lastApprovingStatus;
  int? formType;
  String? photoPath;
  bool? hasNotApprovedData;
  bool? hasNotApprovedPhoto;
  bool? isEmailVerified;
  bool? isPhoneVerified;
  List<Phone>? phones;
  List<dynamic>? relatives;
  int? fillPercentage;
  DeclineComment? declineComment;
  Azure? azure;
  String? azureLogin;

  PersonalAccount({
    this.id,
    this.fulName,
    this.address,
    this.dateBirth,
    this.study,
    this.email,
    this.lastApprovingStatus,
    this.formType,
    this.photoPath,
    this.hasNotApprovedData,
    this.hasNotApprovedPhoto,
    this.isEmailVerified,
    this.isPhoneVerified,
    this.phones,
    this.relatives,
    this.fillPercentage,
    this.declineComment,
    this.azure,
    this.azureLogin,
  });

  factory PersonalAccount.fromJson(Map<String, dynamic> json) =>
      _$PersonalAccountFromJson(json);
  Map<String, dynamic> toJson() => _$PersonalAccountToJson(this);
}