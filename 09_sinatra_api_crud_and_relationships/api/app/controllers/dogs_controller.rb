class DogsController < ApplicationController
  
  get "/dogs" do 
    options = get_dog_json_config(include_dog_walks: params.include?("include_dog_walks"))
  
    Dog.all.to_json(options)
  end

  get "/dogs/:id" do 
    dog = Dog.find(params[:id])
    options = get_dog_json_config(include_dog_walks: params.include?("include_dog_walks"))
    dog.to_json(options)
  end

  # ✅ we want to be able to create dogs through the API

  

  # ✅ we want to be able to update dogs through the API
  

  # ✅ we want to be able to delete dogs through the API
  

  private 

  # a method used to specify which keys are allowed through params into the controller
  # we use this method to create a list of what's permitted to be passed to .create or .update
  # within controller actions.
  def dog_params
    allowed_params = %w()
    params.select {|param,value| allowed_params.include?(param)}
  end

  def get_dog_json_config(include_dog_walks: false)
    options = { methods: [:age] }
    if include_dog_walks
      options.merge!({
        include: {
          dog_walks: {
            methods: [:formatted_time]
          }
        }
      })
    end
    options
  end
end