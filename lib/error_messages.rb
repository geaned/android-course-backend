module ErrorMessage
  # common field errors
  INPUT_MISSING = {code: 0, message: "Поле должно быть заполнено"}
  def self.input_too_long length
    {code: 1, message: "Значение должно содержать не более %d символов" % length}
  end
  def self.input_too_short length
    {code: 2, message: "Значение должно содержать хотя бы %d символов" % length}
  end

  # registration errors
  USER_NAME_ALREADY_TAKEN = {code: 10, message: "Данное имя уже зарегистрировано"}
  EMAIL_ALREADY_TAKEN = {code: 11, message: "Данный адрес уже зарегистрирован"}

  # login errors
  EMAIL_NOT_FOUND = {code: 20, message: "Пользователь с таким адресом не найден"}
  WRONG_PASSWORD = {code: 21, message: "Неверный пароль"}

  # token errors
  ACCESS_KEY_GET_ERROR = {code: 990, message: "Не удалось обработать ключ доступа"}
  ACCESS_TOKEN_EXPIRED = {code: 991, message: "Срок действия ключа доступа истек"}
  REFRESH_KEY_GET_ERROR = {code: 992, message: "Не удалось обработать ключ обновления"}
  REFRESH_TOKEN_EXPIRED = {code: 993, message: "Срок действия ключа обновления истек"}
  INVALID_USER_TOKEN = {code: 994, message: "Попытка доступа с ключом несуществующего пользователя"}
end
