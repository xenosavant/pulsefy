class AssembliesController < ApplicationController

  def create
  @node = current_node
  @assembly = @node.assemblies.build(params[:assembly])
  @assembly.founder = @node.id
  if @assembly.save
     @node.assemblies << @assembly
     if params[:assembly][:avatar].blank?
       redirect_to @assembly
     else
       render 'assemblies/crop'
     end
  else
    redirect_to :controller => 'assemblies', :action => 'new',
                :errors => @assembly.errors.full_messages
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
    redirect_to @assembly
  end

  def quit
    @assembly = Assembly.find(params[:id])
    current_node.assemblies.delete(@assembly)
    redirect_to @assembly
  end

  def new
    @assembly = Assembly.new(params[:node])
  end

  def show_assemblies
    @node = current_node;
    @temp = @node.assemblies
    @assemblies = @temp.paginate(:page => params[:page])
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
