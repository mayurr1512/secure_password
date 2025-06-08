import 'package:flutter/material.dart';
import 'package:password_manager/data/repository/pin_repository.dart';
import 'package:sizer/sizer.dart';
import 'home_screen.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter/services.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final LocalAuthentication auth = LocalAuthentication();
  final PinRepository _pinRepo = PinRepository();

  bool _isCreatingPin = false;
  String _enteredPin = '';

  @override
  void initState() {
    super.initState();
    _unlock();
  }

  Future<void> _unlock() async {
    bool hasPin = await _pinRepo.hasPin();
    bool biometricSuccess = false;

    try {
      if (await auth.isDeviceSupported()) {
        biometricSuccess = await auth.authenticate(
          localizedReason: 'Authenticate to access vault',
          options: const AuthenticationOptions(biometricOnly: false),
        );
      }

      if (biometricSuccess) {
        _goToHome();
      } else {
        setState(() {
          _isCreatingPin = !hasPin;
        });
      }
    } on PlatformException catch (e) {
      debugPrint("Biometric error: $e");
      setState(() {
        _isCreatingPin = !hasPin;
      });
    } finally {

    }
  }

  void _onPinDigitEntered(String digit) async {
    if (_enteredPin.length < 4) {
      setState(() => _enteredPin += digit);
    }

    if (_enteredPin.length == 4) {
      if (_isCreatingPin) {
        await _pinRepo.savePin(_enteredPin);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("PIN Created")),
        );
        _goToHome();
      } else {
        if (await _pinRepo.validatePin(_enteredPin)) {
          _goToHome();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Incorrect PIN")),
          );
          setState(() => _enteredPin = '');
        }
      }
    }
  }

  void _onBackspace() {
    if (_enteredPin.isNotEmpty) {
      setState(() => _enteredPin = _enteredPin.substring(0, _enteredPin.length - 1));
    }
  }

  Widget _buildPinBoxes() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(4, (index) {
        bool filled = index < _enteredPin.length;
        return Container(
          margin: const EdgeInsets.all(8),
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
            color: filled ? Colors.amber : Colors.white,
          ),
          alignment: Alignment.center,
          child: filled ? const Icon(Icons.circle, size: 10) : null,
        );
      }),
    );
  }

  Widget _buildNumberPad() {
    final digits = [
      ['1', '2', '3'],
      ['4', '5', '6'],
      ['7', '8', '9'],
      ['', '0', '<'],
    ];

    return Column(
      children: digits.map((row) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: row.map((char) {
            if (char.isEmpty) {
              return const SizedBox(width: 60, height: 60);
            } else if (char == '<') {
              return IconButton(
                icon: const Icon(Icons.backspace),
                onPressed: _onBackspace,
              );
            } else {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () => _onPinDigitEntered(char),
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    fixedSize: const Size(60, 60),
                  ),
                  child: Text(char, style: const TextStyle(fontSize: 20)),
                ),
              );
            }
          }).toList(),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_isCreatingPin ? 'Create PIN' : 'Enter PIN',
                style: const TextStyle(fontSize: 18)),
            SizedBox(height: 2.h),
            _buildPinBoxes(),
            SizedBox(height: 2.h),
            _buildNumberPad()
          ],
        )
      ),
    );
  }

  void _goToHome() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const HomeScreen()),
    );
  }
}

