class User < ActiveRecord::Base
  has_secure_password

  validates :name, presence: true
  validates :email, presence: true, uniqueness: { case_sensitive: false }
  validates :password, length: { minimum: 3 }
  validates :password_confirmation, presence: true

  before_save :downcase_fields
  def downcase_fields
    self.name.downcase if self.name
    self.email.downcase if self.email
  end
  
  def strip_whitespace
    self.email = self.email.strip if self.email
  end

  def self.authenticate_with_credentials(email, password)
    email = email.downcase if email
    user = User.find_by_email(email)
    if user && user.authenticate(password)
      user
    else
      nil
    end
  end
end
