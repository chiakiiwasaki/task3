class Group < ApplicationRecord
  has_many :group_users, dependent: :destroy
  has_many :users, through: :group_users, dependent: :destroy
  accepts_nested_attributes_for :group_users
  validates :name, presence: true, uniqueness: true
end
