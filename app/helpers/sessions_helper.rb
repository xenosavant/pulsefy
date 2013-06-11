module SessionsHelper

  def sign_in(node)
    cookies.permanent[:remember_token] = node.remember_token
    self.current_node = node
  end

  def signed_in?
    !current_node.nil?
  end

  def signed_in_node
    store_location
    redirect_to pulsein_url, :notice => 'Please pulse in.' unless signed_in?
  end

  def current_node=(node)
    @current_node = node
  end

  def current_node
    @current_node ||= Node.find_by_remember_token(cookies[:remember_token])
  end

  def current_node?(node)
    node == current_node
  end

  def redirect_back_or(default)
    redirect_to(session[:return_to] || default)
    session.delete(:return_to)
  end

  def store_location
    session[:return_to] = request.url
  end

  def sign_out
    self.current_node = nil
    cookies.delete(:remember_token)
  end

end