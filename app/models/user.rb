class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :match_predictions
  has_many :user_competitions
  has_many :competitions, through: :user_competitions
  has_many :game_weeks, through: :competitions

  accepts_nested_attributes_for :match_predictions
end
