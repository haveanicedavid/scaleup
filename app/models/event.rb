class Event < ActiveRecord::Base
  validates :title, presence: true, allow_blank: false,
                    uniqueness: { case_sensitive: false }
  validates :approved, inclusion: [true, false]
  validates :date, presence: true, allow_blank: false
  validates :image_id, presence: true
  validates :venue_id, presence: true

  belongs_to :image
  belongs_to :venue

  has_many :categorizations
  has_many :categories, through: :categorizations
  has_many :items

  scope :active,      -> { joins(:items).uniq.merge(Item.available).open_events }
  scope :open_events, -> { where("date >= ?", Date.today).is_approved }
  scope :is_approved, -> { where approved: true }

  def self.active_events(venue)
    active.where("venue_id = ?", venue.id)
  end

  def month
    date.strftime("%b")
  end

  def day_of_month
    date.strftime("%d")
  end

  def day_of_week
    date.strftime("%a")
  end

  def time
    date.strftime("%m %M %p %Z")
  end

  def venue_name
    venue.name
  end

  def event_banner
    image.img.url(:event_banner)
  end

  def category_name
    categories.first.name
  end

  def venue_location
    venue.location
  end
end
