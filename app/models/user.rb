class User < ApplicationRecord
  include ActiveModel::Validations

  class LengthValidator < ActiveModel::EachValidator
    def validate_each(record, attribute, value)
      unless value.blank?
        unless options[:max] == nil
          if value.length > options[:max]
            record.errors.add(attribute, ErrorMessage::input_too_long(options[:max]))
          end
        end
        unless options[:min] == nil
          if value.length < options[:min]
            record.errors.add(attribute, ErrorMessage::input_too_short(options[:min]))
          end
        end
      end
    end
  end

  validates :user_name, :first_name, :last_name, :email, :password, presence: {message: ErrorMessage::INPUT_MISSING}, on: :create

  validates :user_name, length: {max: 32}, on: :create
  validates :first_name, :last_name, :email, :password, length: {max: 64}, on: :create

  validates :user_name, uniqueness: {message: ErrorMessage::USER_NAME_ALREADY_TAKEN}, on: :create
  validates :email, uniqueness: {message: ErrorMessage::EMAIL_ALREADY_TAKEN}, on: :create
end
