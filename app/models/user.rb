class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable,
         :recoverable, :rememberable, :validatable, :registerable
  has_many :match_predictions
  has_many :user_competitions
  has_many :competitions, through: :user_competitions
  has_many :game_weeks, through: :competitions

  validates_presence_of :username
  validates_uniqueness_of :username
  validates_length_of :username, :minimum => 4, :maximum => 10

  accepts_nested_attributes_for :match_predictions, :reject_if => proc { |attributes| attributes['home_score_guess'].blank? || attributes['away_score_guess'].blank? }

  enum role: [:player, :admin]

  def active_for_authentication?
    super && approved?
  end

  def inactive_message
    approved? ? super : :not_approved
  end
end
