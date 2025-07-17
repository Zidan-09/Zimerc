
enum ServerResponses {
  UnexpectedError = 'unexpected_error',
  NotFound = 'not_found',
  Unauthorized = 'unauthorized',
  Forbidden = 'forbidden',
  BadRequest = 'bad_request',
  ValidationError = 'validation_error',
  Conflict = 'conflict',
  Success = 'success',
  Created = 'created',
  Updated = 'updated',
  Deleted = 'deleted',
  InternalError = 'internal_error'
}

enum UserResponses {
  UserCreated = 'user_created',
  CPFInvalid = 'cpf_invalid',
  UserLoggedIn = 'user_logged_in',
  InvalidPassword = 'invalid_password',
  EmailNotRegistered = 'email_not_registered',
  InvalidEmail = 'invalid_email',
  UserAlreadyExists = 'user_already_exists'
}


export { ServerResponses, UserResponses }