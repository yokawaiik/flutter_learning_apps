class AuthForm {
  String? fullName;
  String? login;
  String? email;
  String? password;
  String? repeatPassword;
  bool agree;

  AuthForm({
    this.fullName,
    this.login,
    this.email,
    this.password,
    this.repeatPassword,
    this.agree = false,
  });
}