import 'dart:math';

enum PasswordStrength { empty, weak, medium, strong }

PasswordStrength getPasswordStrength(String password) {
  if (password.isEmpty) return PasswordStrength.empty;

  if (password.length < 6) return PasswordStrength.weak;

  final hasLetters = RegExp(r'[A-Za-z]').hasMatch(password);
  final hasDigits = RegExp(r'\d').hasMatch(password);
  final hasSpecials = RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password);

  if (hasLetters && hasDigits && hasSpecials && password.length >= 10) {
    return PasswordStrength.strong;
  } else if ((hasLetters && hasDigits) || (hasLetters && hasSpecials)) {
    return PasswordStrength.medium;
  } else {
    return PasswordStrength.weak;
  }
}

String generatePassword({
  int length = 12,
  bool includeNumbers = true,
  bool includeSymbols = true,
}) {
  const upperCase = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  const lowerCase = 'abcdefghijklmnopqrstuvwxyz';
  const numbers = '0123456789';
  const symbols = '!@#\$%^&*()-_=+[]{}|;:,.<>?';

  final rand = Random.secure();
  List<String> chars = [];

  chars.add(upperCase[rand.nextInt(upperCase.length)]);
  chars.add(lowerCase[rand.nextInt(lowerCase.length)]);

  if (includeNumbers) {
    chars.add(numbers[rand.nextInt(numbers.length)]);
  }
  if (includeSymbols) {
    chars.add(symbols[rand.nextInt(symbols.length)]);
  }

  // Remaining random characters
  String availableChars = upperCase + lowerCase;
  if (includeNumbers) availableChars += numbers;
  if (includeSymbols) availableChars += symbols;

  while (chars.length < length) {
    chars.add(availableChars[rand.nextInt(availableChars.length)]);
  }

  // Shuffle the result to avoid predictable pattern
  chars.shuffle(rand);
  return chars.join();
}

