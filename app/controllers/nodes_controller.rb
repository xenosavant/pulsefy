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
      if params[:node][:avatar].blank?
        redirect_to root_url
      else
        render :action => 'crop'
      end
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
        if params[:node][:avatar].blank?
          sign_in @node
          redirect_to root_url
        else
          render :action => 'crop'
        end
      else
        render :action => 'edit'
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

  def show_other_outputs
    @node = Node.find(params[:id])
    @nodes = @node.outputs.paginate(:page => params[:page])
  end

  def show_other_inputs
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

  def crop
    @node = current_node

  end

  def crop_update
      @node = Node.find(params[:id])
      @avatar = @node.avatar
      @node.crop_x = params[:node]['crop_x']
      @node.crop_y = params[:node]['crop_y']
      @node.crop_h = params[:node]['crop_h']
      @node.crop_w = params[:node]['crop_w']
      @node.save
      flash[:success] = "Profile Picture Updated!"
      redirect_to show_path, :id => @node.id
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
