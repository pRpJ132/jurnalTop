// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'personal_account.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Phone _$PhoneFromJson(Map<String, dynamic> json) => Phone(
  phoneType: (json['phone_type'] as num?)?.toInt(),
  phoneNumber: json['phone_number'] as String?,
);

Map<String, dynamic> _$PhoneToJson(Phone instance) => <String, dynamic>{
  'phone_type': instance.phoneType,
  'phone_number': instance.phoneNumber,
};

DeclineComment _$DeclineCommentFromJson(Map<String, dynamic> json) =>
    DeclineComment(
      comment: json['comment'] as String?,
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$DeclineCommentToJson(DeclineComment instance) =>
    <String, dynamic>{
      'comment': instance.comment,
      'updated_at': instance.updatedAt?.toIso8601String(),
    };

Azure _$AzureFromJson(Map<String, dynamic> json) => Azure(
  login: json['login'] as String?,
  hasAzure: json['has_azure'] as bool?,
  hasOffice: json['has_office'] as bool?,
);

Map<String, dynamic> _$AzureToJson(Azure instance) => <String, dynamic>{
  'login': instance.login,
  'has_azure': instance.hasAzure,
  'has_office': instance.hasOffice,
};

PersonalAccount _$PersonalAccountFromJson(Map<String, dynamic> json) =>
    PersonalAccount(
      id: (json['id'] as num?)?.toInt(),
      fulName: json['ful_name'] as String?,
      address: json['address'] as String?,
      dateBirth: json['date_birth'] as String?,
      study: json['study'] as String?,
      email: json['email'] as String?,
      lastApprovingStatus: (json['last_approving_status'] as num?)?.toInt(),
      formType: (json['form_type'] as num?)?.toInt(),
      photoPath: json['photo_path'] as String?,
      hasNotApprovedData: json['has_not_approved_data'] as bool?,
      hasNotApprovedPhoto: json['has_not_approved_photo'] as bool?,
      isEmailVerified: json['is_email_verified'] as bool?,
      isPhoneVerified: json['is_phone_verified'] as bool?,
      phones: (json['phones'] as List<dynamic>?)
          ?.map((e) => Phone.fromJson(e as Map<String, dynamic>))
          .toList(),
      relatives: json['relatives'] as List<dynamic>?,
      fillPercentage: (json['fill_percentage'] as num?)?.toInt(),
      declineComment: json['decline_comment'] == null
          ? null
          : DeclineComment.fromJson(
              json['decline_comment'] as Map<String, dynamic>,
            ),
      azure: json['azure'] == null
          ? null
          : Azure.fromJson(json['azure'] as Map<String, dynamic>),
      azureLogin: json['azure_login'] as String?,
    );

Map<String, dynamic> _$PersonalAccountToJson(PersonalAccount instance) =>
    <String, dynamic>{
      'id': instance.id,
      'ful_name': instance.fulName,
      'address': instance.address,
      'date_birth': instance.dateBirth,
      'study': instance.study,
      'email': instance.email,
      'last_approving_status': instance.lastApprovingStatus,
      'form_type': instance.formType,
      'photo_path': instance.photoPath,
      'has_not_approved_data': instance.hasNotApprovedData,
      'has_not_approved_photo': instance.hasNotApprovedPhoto,
      'is_email_verified': instance.isEmailVerified,
      'is_phone_verified': instance.isPhoneVerified,
      'phones': instance.phones,
      'relatives': instance.relatives,
      'fill_percentage': instance.fillPercentage,
      'decline_comment': instance.declineComment,
      'azure': instance.azure,
      'azure_login': instance.azureLogin,
    };
