class SessionsController < ApplicationController
  include ActionController::Cookies

  def create
    node = Node.find_by_email(params[:session][:email].downcase)
    if node && node.authenticate(params[:session][:password])
      sign_in node
      redirect_to root_path
    else
      redirect_to :controller => 'sessions', :action => 'new', :errors => 'Invalid email/password combination'
    end
  end

  def destroy
    sign_out
    redirect_to pulsein_path
  end

end