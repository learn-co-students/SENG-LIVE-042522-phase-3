class WalksController < ApplicationController

  get "/walks" do 
    if params.include?("include_dogs")
      Walk.all.to_json(
        methods: [:formatted_time],
        include: :dogs
      )
    else
      Walk.all.to_json(
        methods: [:formatted_time]
      )
    end
  end

  get "/walks/recent" do 
    Walk.recent.to_json(
      methods: [:formatted_time]
    )
  end

  get "/walks/:id" do 
    walk = Walk.find(params[:id])
    walk.to_json(
      methods: [:formatted_time]
    )
  end

  private 

  # a method used to specify which keys are allowed through params into the controller
  # we use this method to create a list of what's permitted to be passed to .create or .update
  # within controller actions.
  def walk_params
    
  end
end