class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable,
         :recoverable, :rememberable, :validatable, :registerable
  has_many :match_predictions
  has_many :user_competitions
  has_many :competitions, through: :user_competitions
  has_many :game_weeks, through: :competitions

  accepts_nested_attributes_for :match_predictions, :reject_if => proc { |attributes| attributes['home_score_guess'].blank? || attributes['away_score_guess'].blank? }

  enum role: [:player, :admin]

  def active_for_authentication?
    super && approved?
  end

  def inactive_message
    approved? ? super : :not_approved
  end
end
