import 'package:flutter/material.dart';
import 'package:southsea_cinema/constants.dart';
import 'package:southsea_cinema/models/user_settings.dart';
import 'package:southsea_cinema/widgets/nav_drawer.dart';
import 'package:southsea_cinema/widgets/primary_btn.dart';

class AccountSettings extends StatefulWidget {
  const AccountSettings({super.key});

  @override
  State<AccountSettings> createState() => _AccountSettingsState();
}

class _AccountSettingsState extends State<AccountSettings> {
  late TextEditingController _addressController;
  late TextEditingController _emailController;
  late TextEditingController _patronNumberController;
  bool _receiveNewsLetter = false;
  String _confirmationMessage = '';

  static const String _initialAddress =
      'Some building,\nSome area,\nSome city,\nSome postcode';
  static const String _initialEmail = 'dummy@temp.com';
  static const String _initialPatronNumber = '99999';

  @override
  void initState() {
    super.initState();
    _addressController = TextEditingController(text: _initialAddress);
    _emailController = TextEditingController(text: _initialEmail);
    _patronNumberController = TextEditingController(text: _initialPatronNumber);
  }

  @override
  void dispose() {
    _addressController.dispose();
    _emailController.dispose();
    _patronNumberController.dispose();
    super.dispose();
  }

  void _cancelChanges() {
    setState(() {
      _addressController.text = _initialAddress;
      _emailController.text = _initialEmail;
      _patronNumberController.text = _initialPatronNumber;
      _receiveNewsLetter = false;
      _confirmationMessage = 'Settings changes cancelled.';
    });
  }

  void _saveSettings() {
    final String address = _addressController.text.trim();
    final String email = _emailController.text.trim();
    final int patronNumber = int.tryParse(
          _patronNumberController.text.trim(),
        ) ??
        0;

    final UserSettings settings = UserSettings(
      address: address,
      email: email,
      patronNumber: patronNumber,
      receiveNewsletter: _receiveNewsLetter,
    );

    setState(() {
      _confirmationMessage =
          'Settings saved for patron: ${settings.patronNumber}';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(appTitle, style: cinemaHeaderStyle),
      ),
      drawer: const NavDrawer(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'My Settings',
              style: TextStyle(
                color: cinemaFontWhite,
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            _SettingsFieldLabel(label: 'Address'),
            const SizedBox(height: 8),
            TextField(
              key: const Key('addressField'),
              controller: _addressController,
              maxLines: 4,
              style: const TextStyle(
                color: cinemaFontWhite,
                fontSize: 20,
              ),
              decoration: _settingsInputDecoration().copyWith(
                suffixIcon: IconButton(
                  tooltip: 'Clear address',
                  onPressed: () => _addressController.clear(),
                  icon: const Icon(Icons.close, color: cinemaFontMuted),
                ),
              ),
            ),
            const SizedBox(height: 24),
            _SettingsFieldLabel(label: 'Email Address'),
            const SizedBox(height: 8),
            TextField(
                key: const Key('emailField'),
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                style: const TextStyle(
                  color: cinemaFontWhite,
                  fontSize: 20,
                ),
                decoration: _settingsInputDecoration()),
            const SizedBox(height: 24),
            _SettingsFieldLabel(label: 'Patron Number'),
            const SizedBox(height: 8),
            TextField(
              key: const Key('patronNumberField'),
              controller: _patronNumberController,
              keyboardType: TextInputType.number,
              style: const TextStyle(
                color: cinemaFontWhite,
                fontSize: 20,
              ),
              decoration: _settingsInputDecoration(),
            ),
            const SizedBox(height: 24),
            const _SettingsFieldLabel(label: 'Preferences'),
            const SizedBox(height: 12),
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Receive news by email',
                    style: TextStyle(
                      color: cinemaFontWhite,
                      fontSize: 18,
                    ),
                  ),
                ),
                Switch(
                  key: const Key('newsletterSwitch'),
                  value: _receiveNewsLetter,
                  activeTrackColor: cinemaBrand,
                  onChanged: (bool value) {
                    setState(() {
                      _receiveNewsLetter = value;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: cinemaSurface,
                        foregroundColor: cinemaFontWhite,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                        ),
                      ),
                      onPressed: _cancelChanges,
                      child: const Text(
                        'CANCEL',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: SizedBox(
                    height: 48,
                    child: PrimaryBtn(
                      label: 'SAVE SETTINGS',
                      onPressed: _saveSettings,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            if (_confirmationMessage.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(
                key: const Key('confirmationMessage'),
                _confirmationMessage,
                style: const TextStyle(
                  color: cinemaFontWhite,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  InputDecoration _settingsInputDecoration() {
    return const InputDecoration(
      filled: true,
      fillColor: cinemaSurface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.zero,
        borderSide: BorderSide(color: cinemaFontMuted, width: 1),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.zero,
        borderSide: BorderSide(color: cinemaFontMuted, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.zero,
        borderSide: BorderSide(color: cinemaBrand, width: 2),
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }
}

class _SettingsFieldLabel extends StatelessWidget {
  final String label;

  const _SettingsFieldLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        color: cinemaFontMuted,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
