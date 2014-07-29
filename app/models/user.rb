class User < ActiveRecord::Base
  has_secure_password
  has_many :subscription_events

  validates :email, presence: true, uniqueness: {case_sensitive: false}
  validates :name, presence: true, uniqueness: {case_sensitive: false}
end
