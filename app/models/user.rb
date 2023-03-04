# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  comments_count  :integer
#  email           :string
#  likes_count     :integer
#  password_digest :string
#  private         :boolean
#  username        :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
class User < ApplicationRecord
  validates :email, :uniqueness => { :case_sensitive => false }
  validates :email, :presence => true
  has_secure_password
  validates :comments_count, :presence => true
  validates :likes_count, :presence => true
  validates :private, inclusion: [true, false]
  validates :username, :uniqueness => { :case_sensitive => false }
  validates :username, :presence => true

  has_many(:photos, {
    :foreign_key => "owner_id"
  })
  has_many(:comments, {
    :foreign_key => "author_id"
  })
  has_many(:likes, {
    :foreign_key => "fan_id"
  })
  has_many(:followrequestsreceived, {
    :class_name => "Followrequest",
    :foreign_key => "recipient_id",
    :dependent => :destroy
  })
  has_many(:followrequestssent, {
    :class_name => "Followrequest",
    :foreign_key => "sender_id",
    :dependent => :destroy
  })
  has_many(:recipients, {
    :through => :followrequestssent
  })
  has_many(:senders, {
    :through => :followrequestsreceived
  })
end
