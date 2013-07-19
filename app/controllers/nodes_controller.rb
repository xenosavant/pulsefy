class NodesController < ApplicationController

  def show
    @node = Node.find(params[:id])
    store_location(@node.id)
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
      render 'new'
    end
  end

  def edit
    if !@node.nil?
      correct_node
    else signed_in_node
    end
    @node = current_node
  end

  def update
    @node = Node.find(params[:id])
      if @node.update_attributes(params[:node])
        sign_in @node
        redirect_to @node
      else
        render 'edit'
      end
  end

  def destroy
    Node.find(params[:id]).destroy
    flash[:success] = "Pusler destroyed."
    redirect_to index_path
  end

  def show_outputs
    @node = Node.find(params[:id])
    @nodes = @node.outputs.paginate(:page => params[:page])
  end

  def show_inputs
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

end
