module SessionsHelper

  def sign_in(node)
    cookies.permanent[:remember_token] = node.remember_token
    self.current_node = node
  end

  def signed_in?
    !current_node.nil?
  end

  def signed_in_node
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

  def store_location(location, type)
    session[:return_to_type] = type
    session[:return_to] = location
  end

  def sign_out
    self.current_node = nil
    cookies.delete(:remember_token)
  end

  def return_back_to
    case session[:return_to_type]
      when 'Node'
      case Node.find(session[:return_to]).nil?
        when false
        redirect_to Node.find(session[:return_to])
      end
      when 'Assembly'
        case Assembly.find(session[:return_to]).nil?
          when false
            redirect_to Assembly.find(session[:return_to])
        end
      when 'Pulse'
        case Pulse.find(session[:return_to]).nil?
          when false
            redirect_to Pulse.find(session[:return_to])
        end
      when 'Static'
            redirect_to root_path
      end
  end


  end