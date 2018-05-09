class CampsController < ApplicationController
  before_action :set_camp, only: [:show, :edit, :update, :destroy, :instructors]
  before_action :check_login, only: [:show, :edit, :update, :destroy]
  authorize_resource

  def index
    @active_camps = Camp.all.active.alphabetical.paginate(:page => params[:active_camps]).per_page(10)
    @upcoming_camps = Camp.upcoming.active.chronological.paginate(:page => params[:page]).per_page(10)
    @past_camps = Camp.past.chronological.paginate(:page => params[:page]).per_page(10)
    @inactive_camps = Camp.all.inactive.alphabetical.paginate(:page => params[:inactive_camps]).per_page(1)
  end

  def show
    @instructors = @camp.instructors.alphabetical
    @registrations = @camp.students.alphabetical.to_a
  end

  def edit
  end

  def new
    @camp = Camp.new
  end

  def create
    @camp = Camp.new(camp_params)
    if @camp.save
      redirect_to camp_path(@camp), notice: "#{@camp.name} was added to the system."
    else
      render action: 'new'
    end
  end

  def update
    @camp.update(camp_params)
    if @camp.save
      redirect_to camp_path(@camp), notice: "#{@camp.name} was revised in the system."
    else
      render action: 'edit'
    end
  end

  def destroy
    @camp.destroy
    redirect_to camps_url, notice: "#{@camp.name} was removed from the system."
  end

  def instructors
    @instructors = Instructor.for_camp(@camp).alphabetical
  end

  private
  #start dates need to be converted to dates to fix an issue with datepicker
    def convert_start_and_end_dates
      params[:camp][:start_date] = convert_to_date(params[:camp][:start_date]) unless params[:camp][:start_date].blank?
      params[:camp][:end_date] = convert_to_date(params[:camp][:end_date]) unless params[:camp][:end_date].blank?
    end

    def set_camp
      @camp = Camp.find(params[:id])
    end

    def camp_params
      # convert_start_and_end_dates
      params.require(:camp).permit(:curriculum_id, :location_id, :cost, :start_date, :end_date, :time_slot, :max_students, :active)
    end
end
