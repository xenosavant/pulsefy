class SessionsController < ApplicationController

  def new
  end

  def create
    node = Node.find_by_email(params[:session][:email].downcase)
    if node && node.authenticate(params[:session][:password])
      sign_in node
      redirect_to root_path
    else
      flash.now[:error] = 'Invalid email/password combination'
      render 'new'
    end
  end

  def destroy
    sign_out
    redirect_to pulsein_path
  end

end