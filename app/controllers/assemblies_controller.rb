class AssembliesController < ApplicationController

  before_filter :signed_in_node

  def create
  @node = current_node
  @assembly = @node.assemblies.build(params[:assembly])
  @assembly.founder = @node.id
    if @assembly.save
       @node.assemblies << @assembly
      case params[:assembly][:avatar].blank?
        when true
          redirect_to :controller => 'assemblies', :action => 'show', :id => @assembly.id
       else
         render 'crop'
       end
    else
      redirect_to assemble_path, :errors => @assembly.errors.full_messages
    end
  end

  def destroy
    @assembly = Assembly.find(params[:id])
    @assembly.destroy
    redirect_to view_path(:id => current_node.id)
  end

  def show
    @assembly = Assembly.find(params[:id])
    store_location(@assembly.id, 'Assembly')
    @pulse = @assembly.pulses.new
    @pulses = @assembly.pulses.paginate(:page => params[:page])
  end

  def edit
    @assembly = Assembly.find(params[:id])
  end

  def update
    @assembly = Assembly.find(params[:id])
    if @assembly.update_attributes(params[:assembly])
      if params[:assembly][:avatar].blank?
        redirect_to :controller => 'assemblies', :action => 'show', :id => @assembly.id
      else
        render :action => 'crop'
      end
    end
  end


  def join
    @assembly = Assembly.find(params[:id])
    current_node.assemblies << @assembly
    render @assembly
  end

  def quit
    @assembly = Assembly.find(params[:id])
    current_node.assemblies.delete(@assembly)
    render @assembly
  end

  def new
    @assembly = Assembly.new(params[:node])
  end

  def show_assemblies
    @node = current_node
    @assemblies = @node.assemblies.paginate(:page => params[:page])
  end

  def show_other_assemblies
    @node = Node.find(params[:id])
    @assemblies = @node.assemblies.paginate(:page => params[:page])
  end

  def crop
    @assembly = Assembly.find(params[:id])
  end

  def crop_update
    @assembly = Assembly.find(params[:id])
    @avatar = @assembly.avatar
    @assembly.crop_x = params[:assembly]['crop_x']
    @assembly.crop_y = params[:assembly]['crop_y']
    @assembly.crop_h = params[:assembly]['crop_h']
    @assembly.crop_w = params[:assembly]['crop_w']
    if @assembly.save(params[:assembly])
      redirect_to :controller => 'assemblies', :action => 'show', :id => @assembly.id
    else
      render 'assemblies/crop'
    end

  end

end
