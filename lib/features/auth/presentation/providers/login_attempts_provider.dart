import 'package:hooks_riverpod/hooks_riverpod.dart';

final loginAttemptsProvider = StateProvider<int>((ref) => 0);
final loginBlockedProvider = StateProvider<bool>((ref) => false);

/// Lógica para resetear el bloqueo (llamar desde password_reset_page.dart)
void resetLoginBlock(WidgetRef ref) {
  ref.read(loginAttemptsProvider.notifier).state = 0;
  ref.read(loginBlockedProvider.notifier).state = false;
}
