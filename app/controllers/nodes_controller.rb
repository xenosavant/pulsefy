class NodesController < ApplicationController

  def show
    @node = Node.find(params[:id])
    @pulses = @node.pulses.paginate(:page => params[:page])
  end

  def create
    @node = Node.new(params[:node])
    @node.threshold = 0.5
    if @node.save
      sign_in @node
      flash[:success] = "Pulsefication Complete!"
      redirect_to @node
    else
      render 'new'
    end
  end

  def edit
    id = params[:id]
    @node = Node.find(id)
    if !@node.nil?
    correct_node
    else
    signed_in_node
    end
  end


  def update
    id = params[:id]
    @node = Node.find(id)
      if @node.update_attributes(params[:node])
        flash[:success] = "Pulsefile updated!"
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

  def index
    @nodes = Node.paginate(:page => params[:page])
  end

  def new
    @node = Node.new(params[:node])
  end

  private

  def correct_node
    redirect_to(root_path) unless current_node ==  @node
  end

end
