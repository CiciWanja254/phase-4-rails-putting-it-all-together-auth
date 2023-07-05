class RecipesController < ApplicationController
    def index
      if logged_in?
        recipes = Recipe.all
        render json: recipes, include: :user, status: :ok
      else
        render json: { errors: ["Unauthorized"] }, status: :unauthorized
      end
    end
      
    def create
      if logged_in?
        recipe = current_user.recipes.build(recipe_params)
        if recipe.save
          render json: recipe, include: :user, status: :created
        else
          render json: { errors: recipe.errors.full_messages }, status: :unprocessable_entity
        end
      else
        render json: { errors: ["Unauthorized"] }, status: :unauthorized
      end
    end
  
    private
  
    def recipe_params
      params.permit(:title, :instructions, :minutes_to_complete)
    end
  
    def logged_in?
      !!session[:user_id]
    end
  
    def current_user
      @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
    end  

end
  