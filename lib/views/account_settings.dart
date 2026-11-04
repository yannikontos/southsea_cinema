import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:southsea_cinema/constants.dart';
import 'package:southsea_cinema/models/user_settings.dart';
import 'package:southsea_cinema/widgets/nav_drawer.dart';
import 'package:southsea_cinema/widgets/primary_btn.dart';

const String prefAddress = 'user_address';
const String prefEmail = 'user_email';
const String prefPatronNumber = 'user_patron_number';
const String prefNewsletter = 'user_newsletter';

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
  String _persistenceError = '';

  static const String _initialAddress =
      '42 Example Street,\nSouthsea,\nPortsmouth,\nPO5 1AA';
  static const String _initialEmail = 'alex.morgan@example.com';
  static const int _initialPatronNumber = 12345;

  final SharedPreferencesAsync _preferences = SharedPreferencesAsync();
  UserSettings _savedSettings = const UserSettings(
    address: _initialAddress,
    email: _initialEmail,
    patronNumber: _initialPatronNumber,
  );

  @override
  void initState() {
    super.initState();
    _addressController = TextEditingController(text: _initialAddress);
    _emailController = TextEditingController(text: _initialEmail);
    _patronNumberController =
        TextEditingController(text: _initialPatronNumber.toString());
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    try {
      final UserSettings settings = UserSettings(
        address: await _preferences.getString(prefAddress) ?? _initialAddress,
        email: await _preferences.getString(prefEmail) ?? _initialEmail,
        patronNumber:
            await _preferences.getInt(prefPatronNumber) ?? _initialPatronNumber,
        receiveNewsletter: await _preferences.getBool(prefNewsletter) ?? false,
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _savedSettings = settings;
        _addressController.text = settings.address;
        _emailController.text = settings.email;
        _patronNumberController.text = settings.patronNumber.toString();
        _receiveNewsLetter = settings.receiveNewsletter;
        _persistenceError = '';
      });
    } catch (error) {
      if (!mounted) {
        return;
      }
      setState(() {
        _persistenceError = 'Could not load saved settings: $error';
      });
    }
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
      _addressController.text = _savedSettings.address;
      _emailController.text = _savedSettings.email;
      _patronNumberController.text = _savedSettings.patronNumber.toString();
      _receiveNewsLetter = _savedSettings.receiveNewsletter;
      _confirmationMessage = 'Settings changes cancelled.';
    });
  }

  Future<void> _saveSettings() async {
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

    try {
      await Future.wait<void>([
        _preferences.setString(prefAddress, settings.address),
        _preferences.setString(prefEmail, settings.email),
        _preferences.setInt(prefPatronNumber, settings.patronNumber),
        _preferences.setBool(prefNewsletter, settings.receiveNewsletter),
      ]);

      if (!mounted) {
        return;
      }

      setState(() {
        _savedSettings = settings;
        _persistenceError = '';
        _confirmationMessage =
            'Settings saved for patron: ${settings.patronNumber}';
      });
    } catch (error) {
      if (!mounted) {
        return;
      }
      setState(() {
        _persistenceError = 'Could not save settings: $error';
      });
    }
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
            if (_persistenceError.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(
                key: const Key('persistenceError'),
                _persistenceError,
                style: const TextStyle(color: Colors.redAccent),
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
