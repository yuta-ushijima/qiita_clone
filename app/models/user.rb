class User < ApplicationRecord

  # constant
  VALID_EMAIL_REGEX = %r{\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z}.freeze
  VALID_PASSWORD_REGEX = %r{\A([\w]+)([@¥|\-]?)([-(-)]*){6,50}\z}.freeze

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  after_create :update_access_token!

  before_save  do
    self.email = email.downcase
  end

  # validates
  with_options presence: true do
    validates :first_name
    validates :last_name
  end

  validates :email, presence: true, uniqueness: true, format: { with: VALID_EMAIL_REGEX }
  validates :password, presence: true, format: { with: VALID_PASSWORD_REGEX }, length: { minimum: 6, maximum: 50}

  def update_access_token!
    self.update!(access_token: "#{self.id}:#{Devise.friendly_token}")
  end
end
