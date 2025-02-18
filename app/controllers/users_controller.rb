class UsersController < ApplicationController
    def create
      user = User.new(user_params)
      if user.save
        session[:user_id] = user.id
        render json: user, status: :created
      else
        render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
      end
    end
  
    def show
      if logged_in?
        user = User.find_by(id: session[:user_id])
        if user
          render json: user, status: :ok
        else
          render json: { error: 'User not found' }, status: :not_found
        end
      else
        render json: { error: 'Unauthorized' }, status: :unauthorized
      end
    end
    
    private
  
    def logged_in?
      !!session[:user_id]
    end
  
    def user_params
      params.permit(:username, :password, :password_confirmation, :image_url, :bio)
    end
end
  