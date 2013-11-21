class NodesController < ApplicationController

  def show
    @node = Node.find(params[:id])
    store_location(@node.id, 'Node')
    @pulses = @node.pulses.paginate(:page => params[:page])
  end

  def create
    @node = Node.new(params[:node])
    @node.threshold = 0.5
    if @node.save
      sign_in @node
      flash[:success] = "Pulsefication Complete!"
      redirect_to root_url
    else
      redirect_to :controller => 'nodes', :action => 'new', :errors => @node.errors.full_messages
    end
  end

  def edit
    if !@node.nil?
      correct_node
    else signed_in_node
    end
    @node = current_node
  end

  def picup
    if !@node.nil?
      correct_node
    else signed_in_node
    end
    @node = current_node
  end

  def account
    if !@node.nil?
      correct_node
    else signed_in_node
    end
    @node = current_node
  end

  def update
    @node =  Node.find(current_node)
      if @node.update_attributes(params[:node])
        sign_in @node
        redirect_to root_path
      else
        render 'edit'
      end
  end

  def destroy
    if is_an_admin?
    Node.find(params[:id]).destroy
    flash[:success] = "Pusler destroyed."
    redirect_to root_path
    end
  end

  def show_outputs
    @node = current_node
    @nodes = @node.outputs.paginate(:page => params[:page])
  end

  def show_inputs
    @node = current_node
    @nodes = @node.inputs.paginate(:page => params[:page])
  end

  def show_others_outputs
    @node = Node.find(params[:id])
    @nodes = @node.outputs.paginate(:page => params[:page])
  end

  def show_others_inputs
    @node = Node.find(params[:id])
    @nodes = @node.inputs.paginate(:page => params[:page])
  end

  def members
    @assembly = Assembly.find(params[:id])
    @nodes = @assembly.nodes.paginate(:page => params[:page])
  end

  def new
    @node = Node.new(params[:node])
  end

  private

  def correct_node
    redirect_to(root_path) unless current_node ==  @node
  end

  def is_an_admin?
    case @check = current_node.admin
      when true
         true
      else
        redirect_to pulsein_path
        false
    end
  end
end
