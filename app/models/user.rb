require 'bcrypt'

class User < ActiveRecord::Base
	include BCrypt
	validates_presence_of   :username,      on: :create
  validates_uniqueness_of :username,      on: :create
  validates_presence_of   :password,      on: :create
  serialize :devices

  def password=(secret)
    write_attribute(:password, BCrypt::Password.create(secret))
  end
end
