class DogWalk < ActiveRecord::Base
  belongs_to :dog
  belongs_to :walk

  scope :with_poop, -> { where(pooped: true) }

  delegate :formatted_time, to: :walk
  # defines a method like this:
  # def formatted_time
  #   walk.formatted_time
  # end

  # this method needs to handle creating a dog_walk and also updating an existing dog_walk
  # upon creation, this method should create a new walk at the given time
  # upon update, this method should update the walk to the given time
  def walk_time=(time)
    if walk
      self.walk.update(time: time)
    else
      self.walk = Walk.create(time: time)
      # self.create_walk(time: time)
    end
  end

 
end