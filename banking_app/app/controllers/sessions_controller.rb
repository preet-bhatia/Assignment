class SessionsController < ApplicationController
    def new
        @user =  User.new
    end
    def create
        user = User.find_by(email:params[:sessions][:email].downcase)
        if user && user.authenticate(params[:sessions][:password])
            session[:user_id] = user.customer_id
            flash[:notice] = "Log in successful"
            redirect_to user
        else
            flash.now[:alert] = "Wrong login info"
            render 'new'
        end
    end
    def destroy
        session[:user_id] = nil
        flash[:notice] = "Log Out successful"
        redirect_to root_path
    end
end