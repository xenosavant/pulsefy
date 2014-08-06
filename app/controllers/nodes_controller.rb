class NodesController < ApplicationController

  include SessionsHelper
  before_filter :signed_in_node, :except => [:new, :create]

  def show
    @node = Node.find(params[:id])
    @message = Message.new
    store_location(@node.id, 'Node')
    store_receiver(params[:id])
    @pulses = @node.pulses.paginate(:page => params[:page])
  end

  def create
    @node = Node.new(params[:node])
    @node.update_attributes(:threshold => 0.5, :hub => false, :admin => false, :verified => false )
    if @node.save
      sign_in @node
      #@node.pulses << Pulse.find()
      @origin_node = Node.find(1)
      @synapse = @origin_node.connectors.build
      @synapse.update_attributes(:strength => 0.5, :output_id => @node.id)
      redirect_to root_path
    else
      redirect_to :controller => 'nodes', :action => 'new', :errors => @node.errors.full_messages
    end
  end

  def index
    @nodes = Node.search(params[:search]).paginate(:page => params[:page])
  end

  def edit
    @node = current_node
  end


  def account
    case  @node.nil?
      when false
      correct_node
    else signed_in_node
    end
    @node = current_node
  end

  def update
    @node = current_node
      if @node.update_attributes(params[:node])
        if params[:node][:avatar].blank?
          redirect_to "/show/#{@node.id}", :errors => @node.errors.full_messages
        else
          render 'crop'
        end
      else
          redirect_to edit_path(:id => @node.id, :errors => @node.errors.full_messages)
      end
  end

  def update_selftag
    @node = current_node
    if @node.update_attributes(params[:node])
        redirect_to "/show/#{@node.id}", :errors => @node.errors.full_messages
    else
        redirect_to account_path(:id => @node.id, :errors => @node.errors.full_messages)
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
        @node.reprocess_avatar
        redirect_to :controller => 'nodes', :action => 'show', :id => params[:id]
      else
        redirect_to :controller => 'nodes', :action => 'crop'
      end

  end

  private

  def correct_node
    redirect_to(root_path) unless current_node ==  @node
  end


end
