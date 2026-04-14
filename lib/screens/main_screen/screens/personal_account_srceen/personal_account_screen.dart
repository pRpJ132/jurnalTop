import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_app/models/personal_account.dart';
import 'package:my_app/network/api_client.dart';
import 'package:skeletonizer/skeletonizer.dart';

class PersonalAccountScreen extends StatefulWidget {
  const PersonalAccountScreen({super.key});

  @override
  State<PersonalAccountScreen> createState() => _PersonalAccountScreenState();
}

class _PersonalAccountScreenState extends State<PersonalAccountScreen> {
  static final ValueNotifier<PersonalAccount?> _profile = ValueNotifier(null);
  final ValueNotifier<bool> _isLoading = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  @override
  void dispose() {
    _isLoading.dispose();
    super.dispose();
  }

  void loadProfile() async {
    try {
      _isLoading.value = true;
      final response = await ApiClient.get("profile/operations/settings");
      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        _profile.value = PersonalAccount.fromJson(body);
      }
    } finally {
      _isLoading.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Личный кабинет".toUpperCase(),
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const SizedBox(height: 12),
            ValueListenableBuilder<bool>(
              valueListenable: _isLoading,
              builder: (context, isLoading, _) {
                if (isLoading && _profile.value == null) {
                  final newProfile = PersonalAccount(
                    fulName: '-----------',
                    dateBirth: "2009-07-05",
                    address: '-----------------------',
                    study: '---------------',
                    email: '---------------------',
                    fillPercentage: 85,
                    phones: [
                      Phone(
                        phoneNumber: '---------------'
                      )
                    ]
                  );
                  return Skeletonizer(
                    enabled: true,
                    child: _buildProfileCard(context, newProfile)
                  );
                }

                return ValueListenableBuilder<PersonalAccount?>(
                  valueListenable: _profile,
                  builder: (context, profile, _) {
                    if (profile == null) {
                      return const Center(child: Text("Нет данных"));
                    }
                    return _buildProfileCard(context, profile);
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileCard(BuildContext context, PersonalAccount profile) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: .start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              crossAxisAlignment: .start,
              children: [
                if (profile.photoPath != null)
                  ClipOval(
                    child: Image.network(
                      profile.photoPath!,
                      width: 72,
                      height: 72,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) =>
                          const Icon(Icons.person, size: 72),
                    ),
                  ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        profile.fulName ?? "—",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      if (profile.dateBirth != null)
                        Text(
                          "Дата рождения: ${profile.dateBirth}",
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(),
        
            _buildInfoRow(CupertinoIcons.envelope_fill, "Email", profile.email),
            _buildInfoRow(CupertinoIcons.placemark_fill, "Адрес", profile.address),
            if (profile.phones != null && profile.phones!.isNotEmpty)
              _buildInfoRow(
                CupertinoIcons.phone_fill,
                "Телефон",
                profile.phones!.first.phoneNumber,
              ),
        
            const Divider(),
        
            if (profile.fillPercentage != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Заполненность профиля: ${profile.fillPercentage}%"),
                    const SizedBox(height: 4),
                    LinearProgressIndicator(
                      value: (profile.fillPercentage ?? 0) / 100,
                      minHeight: 6,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ],
                ),
              ),
        
            if (profile.declineComment?.comment != null)
              Container(
                margin: const EdgeInsets.all(12),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: Colors.red.shade200),
                ),
                child: Column(
                  crossAxisAlignment: .start,
                  mainAxisSize: .min,
                  children: [
                    Text(
                      "Запрос на изменения профиля отклонен",
                      style: const TextStyle(color: Colors.red),
                    ),
                    Flexible(
                      child: Text(
                        "Комментарий: ${profile.declineComment!.comment!}",
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                    Flexible(
                      child: Text(
                        "Дата отклонения: ${DateFormat('dd MMMM yyyy', 'ru').format(
                          profile.declineComment?.updatedAt ?? DateTime.now()
                        )}",
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              ),
        
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
              child: Row(
                children: [
                  _buildBadge(
                    "Email подтверждён",
                    profile.isEmailVerified == true,
                  ),
                  const SizedBox(width: 8),
                  _buildBadge(
                    "Телефон подтверждён",
                    profile.isPhoneVerified == true,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.grey),
          const SizedBox(width: 8),
          Text("$label: ", style: const TextStyle(fontWeight: FontWeight.w600)),
          Expanded(child: Text(value ?? "—")),
        ],
      ),
    );
  }

  Widget _buildBadge(String label, bool ok) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          ok ? CupertinoIcons.check_mark_circled_solid : Icons.cancel,
          size: 16,
          color: ok ? Colors.green : Colors.grey,
        ),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}