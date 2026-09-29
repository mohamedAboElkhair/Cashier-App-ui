/// Structured failure for the public registration POST, so the wizard can
/// route backend validation problems to the exact field that caused them
/// (e.g. a duplicate-username 422's `errors.username`) instead of flattening
/// everything into one snackbar string.
class RegistrationFailure {
  const RegistrationFailure({
    required this.message,
    this.fieldErrors = const {},
  });

  /// Human-readable summary — used for the general (non-field) surface.
  final String message;

  /// Backend field name (`username`, `email`, `id_number`, `unitid`, …) →
  /// first validation message for that field. Empty when the failure isn't
  /// attributable to specific fields (network down, 500, …).
  final Map<String, String> fieldErrors;

  bool get hasFieldErrors => fieldErrors.isNotEmpty;
}
