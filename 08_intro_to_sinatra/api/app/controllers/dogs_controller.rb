class DogsController < ApplicationController
  
  get "/dogs" do 
    puts params.include?("include_dog_walks")
    if params.include?("include_dog_walks")
      Dog.all.to_json(
        methods: [:age],
        include: {
          dog_walks: {
            methods: [:formatted_time]
          }
        }
      )
    else
      Dog.all.to_json(
        methods: [:age]
      )
    end
  end

  private 

  # a method used to specify which keys are allowed through params into the controller
  # we use this method to create a list of what's permitted to be passed to .create or .update
  # within controller actions.
  def dog_params
    
  end

end