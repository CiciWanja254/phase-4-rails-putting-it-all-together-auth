class SessionsController < ApplicationController
    def create
        user = User.find_by(username: params[:username])
        if user && user.authenticate(params[:password])
            session[:user_id] = user.id
            render json: user, status: :ok
        else
            render json: { errors: ["Unauthorized"] }, status: :unauthorized
        end
    end

    def destroy
        if logged_in?
          session[:user_id] = nil
          head :no_content
        else
            render json: { errors: ["Unauthorized"] }, status: :unauthorized
        end
    end

    private

    def logged_in?
        !!session[:user_id]
    end
    
end
  