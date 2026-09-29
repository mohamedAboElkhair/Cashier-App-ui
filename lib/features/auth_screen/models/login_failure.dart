/// A failed login attempt, distinguishing the forced first-login password
/// reset from ordinary failures.
///
/// Owner-assisted accounts (minor household members) are created server-side
/// with a temporary password and `must_reset_password = true`. For those, the
/// login endpoint never issues a token until the holder sends a `new_password`
/// together with the temporary `password` in the same call:
///
///  - 403 + `message_key: auth.password_reset_required` → the client must
///    switch the login UI into set-new-password mode ([resetRequired]).
///  - 422 + `message_key: auth.new_password_must_differ` → the chosen new
///    password equals the temporary one ([newPasswordMustDiffer], shown
///    inline on the new-password field).
///
/// Every other failure (401 bad credentials, network, …) is a plain
/// [message]-only failure with both flags false.
class LoginFailure {
  final String message;

  /// The server refused to issue a token because the account still carries
  /// `must_reset_password` — the user has to choose a new password first.
  final bool resetRequired;

  /// The reset was attempted but the new password matched the temporary one.
  /// Only ever true together with [resetRequired].
  final bool newPasswordMustDiffer;

  const LoginFailure(
    this.message, {
    this.resetRequired = false,
    this.newPasswordMustDiffer = false,
  });
}
