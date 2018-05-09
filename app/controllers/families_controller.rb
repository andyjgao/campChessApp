class FamiliesController < ApplicationController
  before_action :set_family, only: [:show, :edit, :update, :family_payment]
  before_action :check_login, only: [:show, :edit, :update, :destroy]
  authorize_resource

  def index
    @all_families = Family.alphabetical.paginate(:page => params[:page]).per_page(10)
    @active_families = Family.active.alphabetical.paginate(:page => params[:page]).per_page(10)
    @inactive_families = Family.inactive.alphabetical.paginate(:page => params[:page]).per_page(10)
  end

  def show
    #displays a families children
    @family_students = @family.students.alphabetical
    #displays a families registrations
    @family_registrations =@family.registrations
  end

  def new
    @family = Family.new
  end

  def edit
  end

  #method to display family payments for an admin
  def family_payment
    @family_registrations =@family.registrations
  end

  def create
    @user = User.new(user_params)
    @user.role = "parent"
    @family = Family.new(family_name: params[:family_name])
    # if @family.save
    #   redirect_to @family, notice: "#{@family.family_name} family was added to the system."
    # else
    #   render action: 'new'
    # end


    if !@user.save
      @family.valid?
      render action: 'new'
    else
      @family.user_id = @user.id
      if @family.save
        flash[:notice] = "Successfully created #{@family.proper_name}."
        redirect_to family_path(@family) 
      else
        render action: 'new'
      end      
    end



  end

  def update
    if @family.update(family_params)
      redirect_to @family, notice: "#{@family.family_name} family was revised in the system."
    else
      render action: 'edit'
    end
  end

  private
    def set_family
      @family = Family.find(params[:id])
    end

    def family_params
      params.require(:family).permit(:family_name, :parent_first_name, :email, :phone, :active)
    end
end