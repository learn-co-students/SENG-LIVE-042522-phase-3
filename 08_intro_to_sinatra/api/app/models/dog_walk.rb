class DogWalk < ActiveRecord::Base
  belongs_to :dog
  belongs_to :walk

  scope :with_poop, -> { where(pooped: true) }

  delegate :formatted_time, to: :walk
  # defines a method like this:
  # def formatted_time
  #   walk.formatted_time
  # end

  
end