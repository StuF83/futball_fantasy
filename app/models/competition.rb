class Competition < ApplicationRecord
  has_many :users, through: :competitions_users
end
