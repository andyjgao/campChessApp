class RegistrationsController < ApplicationController
  include AppHelpers::Cart
  before_action :set_registration, only: [:show, :edit, :update, :destroy]


  def index
    #list of registrations registrationed with the by student scope
    @registrations = Registration.by_student.paginate(:page => params[:page]).per_page(10)
    # @deposit_registrations = Registration.by_student.deposit_only.paginate(:page => params[:page]).per_page(10)
    # @full_registrations = Registration.by_student.paid.paginate(:page => params[:page]).per_page(10)
  end

  def show
  end

  def new
    @registration = Registration.new
    @registration.camp_id = params[:camp_id] unless params[:camp_id].nil?
    @students = (Student.active.at_or_above_rating(@registration.camp.curriculum.min_rating).below_rating(@registration.camp.curriculum.max_rating).alphabetical.to_a) - (@registration.camp.students)
  end

  def edit
  end

  def create
    @registration = Registration.new(registration_params)
    if @registration.save
      redirect_to @registration, notice: "You have successfully registered #{@registration.student.proper_name} for #{@registration.camp.curriculum.camp.name}."
    else
      render action: 'new'
    end
  end

  def update
    if @registration.update(registration_params)
      redirect_to @registration, notice: "This registration was revised in the system."
    else
      render action: 'edit'
    end
  end

  def destroy
    @registration.destroy
    redirect_to registrations_url, notice: "This registration was removed from the system."
  end

  def add_to_cart
    add_registration_to_cart(params[:registration][:camp_id], params[:registration][:student_id])
    redirect_to home_path, notice: "Added 1  to the cart."

  end

  def remove_from_cart

    remove_registration_from_cart(params[:ids][0], params[:ids][1])
    flash[:notice] = "Removed 1 from the cart."
    redirect_to view_cart_path
  end


  def view_cart
    @total_cost = 0
    if !logged_in? || current_user.nil? || current_user.role?(:instructor)
      flash[:error] = "You are not authorized to take this action. Please log in as an appropriate user."
      redirect_to home_path
    end

  end

  def pay
  end
  def checkout

    card_num = params[:registration][:credit_card_number].to_i
    exp_yr = params[:registration][:expiration_year].to_i
    exp_mo = params[:registration][:expiration_month].to_i
    reg_ids = get_array_of_ids_for_generating_registrations

    res_regs = []
    reg_ids.each{|r_id|


      reg = Registration.new(camp_id: r_id[0],student_id: r_id[1], credit_card_number: card_num, expiration_year: exp_yr,  expiration_month: exp_mo)#,


      # reg = Registration.new(camp: r_id[0],student: r_id[1])
      reg.save
      reg.pay
      res_regs.push(reg)
    }
    clear_cart
    res_regs
    redirect_to camps_path, notice: "You have successfully registered for #{res_regs.length} camp(s)!."

  end

  private
    def set_registration
      @registration = Registration.find(params[:id])
    end

    def registration_params
      params.require(:registration).permit(:camp_id, :student_id, :payment_status, :points_earned)
    end
end
