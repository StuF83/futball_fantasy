class Competition < ApplicationRecord
  has_many :user_competitions
  has_many :users, through: :user_competitions
end
