module Messages
  SUCCESS = {
    user_created: "User successfully created.",
    login_successful: "Login successful.",
    logout_successful: "Logout successful."
  }.freeze

  ERROR = {
    invalid_credentials: "Invalid email or password.",
    unauthorized: "You are not authorized to perform this action.",
    record_not_found: "Record not found.",
    short_password: "Password must be at least 8 characters long."
  }.freeze
end
