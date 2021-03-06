class Outing < ApplicationRecord
  has_many :suggestions
  has_many :user_outings
  has_many :users, through: :user_outings

  validates :name, presence: true
  validates :voting_deadline, presence: true
  validates :event_start, presence: true

  def timer_formatted
    time = time_left.abs
    days = time / 86400
    time = time - (days * 86400)
    hours = time / 3600
    time = time - (hours * 3600)
    minutes = time / 60
    time =- time - (minutes * 60)
    "#{days} days #{hours} hours #{minutes} minutes"
  end

  def voting_over?
    time_left <= 0
  end

  def top_suggestions
    self.suggestions.sort_by {|suggestion| suggestion.likes.count}.reverse[0..2]
  end

  def top_suggestion
    top_suggestions.first
  end

  private

  def time_left
    (self.voting_deadline - Time.now).to_i
  end
end
