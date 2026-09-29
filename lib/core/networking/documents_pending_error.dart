// Shared helpers for the owner-verification "documents pending" gate
// (Task 6/7/8): the backend returns a 403 shaped like
// `{"reason": "documents_pending", ...}` when an action is blocked pending
// document verification. Repos encode that as a sentinel-prefixed `Left`
// string (via [documentsPendingError]) instead of changing their
// `Either<String, T>` error shape; UI layers detect the sentinel (via
// [isDocumentsPendingError]) to show a friendly, localized message instead
// of the raw error text. The raw sentinel string must never be shown to the
// user directly.

/// The sentinel prefix used to flag a `documents_pending` error. See the
/// file-level comment above for the full contract.
const String documentsPendingReason = 'documents_pending';

/// If [data] is a 403 body shaped like `{"reason": "documents_pending", ...}`,
/// returns a `Left`-ready string prefixed with the [documentsPendingReason]
/// sentinel so the UI layer can special-case it via [isDocumentsPendingError]
/// without ever displaying the raw string to the user. Returns null
/// otherwise.
///
/// By default the human-readable message is read from the `message` key of
/// [data]. Pass [messageExtractor] to customize that lookup (e.g. to also
/// check `msg`/`error` keys, as `AccessRepo` does) while keeping the sentinel
/// and fallback behavior identical.
String? documentsPendingError(
  dynamic data, {
  String? Function(dynamic data)? messageExtractor,
}) {
  if (data is Map && data['reason'] == 'documents_pending') {
    final message = (messageExtractor != null ? messageExtractor(data) : null) ??
        _defaultMessageFromData(data) ??
        'Documents pending verification';
    return 'documents_pending: $message';
  }
  return null;
}

String? _defaultMessageFromData(dynamic data) {
  if (data is Map) {
    return data['message']?.toString();
  }
  return null;
}

/// Whether [error] is a sentinel string produced by [documentsPendingError],
/// indicating the UI should show the localized "documents pending" message
/// instead of the raw error text.
bool isDocumentsPendingError(String error) =>
    error.startsWith(documentsPendingReason);
