require 'rails_helper'

RSpec.describe User, type: :model do

  describe 'Validations' do
    
    subject { described_class.create(
      :name => "TEST",
      :email => "test@test.com",
      :password => "abc",
      :password_confirmation => "abc" 
    )}

    it "is valid with valid attributes" do
      expect(subject).to be_valid
    end

    it "is not valid without name" do
      subject.name = nil
      expect(subject).to_not be_valid
      expect(subject.errors.full_messages).to include("Name can't be blank")
    end

    it "is not valid without email" do
      subject.email = nil
      expect(subject).to_not be_valid
      expect(subject.errors.full_messages).to include("Email can't be blank")
    end
    
    it "is not valid if email has already been taken" do
      @user1 = described_class.create(name: "123", email: "123@email.com", password: "123", password_confirmation: "123")
      @user2 = described_class.create(name: "456", email: "123@EMAIL.COM", password: "456", password_confirmation: "456")
      expect(@user2).to_not be_valid
      expect(@user2.errors.full_messages).to include("Email has already been taken")
    end

    it "is not valid without password" do
      subject.password = nil
      expect(subject).to_not be_valid
      expect(subject.errors.full_messages).to include("Password can't be blank")
    end

    it "is not valid without password length less than minimum" do
      subject.password = "a"
      subject.password_confirmation = "a"
      expect(subject).to_not be_valid
      expect(subject.errors.full_messages).to include("Password is too short (minimum is 3 characters)")
    end

    it "is not valid when password and password_confirmation are not matched" do
      subject.password_confirmation = "bca"
      expect(subject).to_not be_valid
      expect(subject.errors.full_messages).to include("Password confirmation doesn't match Password")
    end

  end

  describe '.authenticate_with_credentials' do
    it "will successfully sign in with correct email and password" do
      user = User.authenticate_with_credentials(subject.email, subject.password)
      expect(user)==subject
    end
    
    it "will not successfully sign in with wrong email or password" do
      user1 = User.authenticate_with_credentials(subject.email, "123")
      user2 = User.authenticate_with_credentials("abc@gmail.com", subject.email)
      expect(user1)==nil
      expect(user2)==nil
    end
    
    it "will successfully sign in with correct email and password even have extra spaces in email address" do
      email = subject.strip_whitespace
      user = User.authenticate_with_credentials(email, subject.password)
      expect(user)==subject
    end

    it "will successfully sign in with correct email and password even wrong case in email address" do
      email = subject.email.upcase if subject.email
      user = User.authenticate_with_credentials(email, subject.password)
      expect(user)==subject
    end
  end

end
