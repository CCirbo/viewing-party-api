class User < ApplicationRecord
  validates :name, presence: true
  validates :username, presence: true, uniqueness: true
  validates :password, presence: { require: true }
  has_secure_password
  has_secure_token :api_key
  has_many :user_parties
  has_many :viewing_parties, through: :user_parties

  # def valid_api_key?
  #   if self.api_key == "valid_api_key"
  #     return true
  #   else
  #     return false
  #   end
  # end

  # def valid_api_key?
  #   self.api_key == "valid_api_key"
  # end

  def valid_api_key?(key)
    self.api_key == key
  end
end