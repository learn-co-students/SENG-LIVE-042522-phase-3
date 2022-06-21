class DogWalksController < ApplicationController
  
  # ✅ we want to be able to create dog_walks through the API
  post "/dog_walks" do 
    
  end

  # ✅ we want to be able to update dog_walks through the API
  patch "/dog_walks/:id" do
    
  end

  # ✅ we want to be able to delete dog_walks through the API
  delete "/dog_walks/:id" do
   
  end

  private 

  # a method used to specify which keys are allowed through params into the controller
  # we use this method to create a list of what's permitted to be passed to .create or .update
  # within controller actions.
  def dog_walk_params
    allowed_params = %w(dog_id walk_time pooped)
    params.select {|param,value| allowed_params.include?(param)}
  end

  def get_dog_walk_json_config()
    {
      methods: [:formatted_time]
    }
  end
  
end