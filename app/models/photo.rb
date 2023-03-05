# == Schema Information
#
# Table name: photos
#
#  id             :integer          not null, primary key
#  caption        :text
#  comments_count :integer
#  image          :string
#  likes_count    :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  owner_id       :integer
#
class Photo < ApplicationRecord
  validates :caption, :presence => true
  validates :comments_count, :presence => true
  validates :image, :presence => true
  validates :likes_count, :presence => true
  validates :owner_id, :presence => true
  
  belongs_to(:owner, {
    :class_name => "User"
  })
  has_many(:comments)
  has_many(:likes)
  has_many(:fans, {
    :through => :likes
  })
end
