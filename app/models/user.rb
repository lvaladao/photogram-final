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
  has_many(:follow_requests_received, {
    :class_name => "FollowRequest",
    :foreign_key => "recipient_id",
    :dependent => :destroy
  })
  has_many(:follow_requests_sent, {
    :class_name => "FollowRequest",
    :foreign_key => "sender_id",
    :dependent => :destroy
  })
  has_many(:recipients, {
    :through => :follow_requests_sent
  })
  has_many(:senders, {
    :through => :follow_requests_received
  })

  def feed_size
    size = 0
    requests = self.follow_requests_sent.select { |fr| fr.status == "accepted" }
    
    requests.each do |request|
      size = size + request.recipient.photos.length()
    end
    
    return size
  end

  def discover_size
    size = 0
    requests = self.follow_requests_sent.select { |fr| fr.status == "accepted" }
    
    requests.each do |request|
      size = size + request.recipient.likes.length()
    end
    
    return size
  end
end
