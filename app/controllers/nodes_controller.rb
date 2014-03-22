class NodesController < ApplicationController

  before_filter :signed_in_node, :except => [:new, :create, :crop_update]

  def show
    @node = Node.find(params[:id])
    @id = @node.id
    @message = Message.new
    store_location(@node.id, 'Node')
    store_receiver(params[:id])
    @pulses = @node.pulses.paginate(:page => params[:page])
  end

  def create
    @node = Node.new(params[:node])
    @node.threshold = 0.5
    if @node.save
      sign_in @node
      flash[:success] = "Pulsefication Complete!"
      redirect_to root_path
    else
      redirect_to :controller => 'nodes', :action => 'new', :errors => @node.errors.full_messages
    end
  end


  def edit
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
          sign_in(@node)
          redirect_to :controller => 'nodes', :action => 'show', :id => @node.id
        else
          render :action => 'crop'
        end
      end
  end

  def destroy
    if is_an_admin?
    Node.find(params[:id]).destroy
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
      if @node.save(params[:node])
        sign_in(@node)
        #flash[:success] = "Pulsefeed Updated!"
        redirect_to :controller => 'nodes', :action => 'show', :id => params[:id]
      else
        render 'crop'
      end

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
         false
         redirect_to pulsein_path
    end
  end
end
