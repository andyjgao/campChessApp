class StudentsController < ApplicationController
  before_action :set_student, only: [:show, :edit, :update]
  before_action :check_login
  authorize_resource

  def index
     if current_user.role?(:instructor)
       @students =  current_user.instructor.students.alphabetical.paginate(:page => params[:students]).per_page(12)
     elsif current_user.role?(:parent)
       @students = current_user.family.students.alphabetical.paginate(:page => params[:students]).per_page(12)
     else
       @students =  Student.all.alphabetical.paginate(:page => params[:students]).per_page(12)
     end
   end
  def show
    @upcoming_student_camps = @student.camps.upcoming.chronological
    @past_student_camps = @student.camps.past.chronological
 end

  def new
    @student = Student.new
  end

  def edit
  end

  def create
    @student = Student.new(student_params)
    if @student.save
      redirect_to @student, notice: "#{@student.proper_name} was added to the system"
    else
      render action: 'new'
    end
  end

  def update
    if @student.update(student_params)
      redirect_to @student, notice: "#{@student.proper_name} was revised in the system"
    else
      render action: 'edit'
    end
  end

  def destroy
    @student.destroy
    redirect_to students_url, notice: "This student was removed from the system."
  end

  private
    #custom code to convert dob due to datepicker
    def convert_date_of_birth
      params[:student][:date_of_birth] = convert_to_date(params[:student][:date_of_birth]) unless params[:student][:date_of_birth].blank?
    end

    def set_student
      @student = Student.find(params[:id])
    end

    def student_params
      # convert_date_of_birth
      params.require(:student).permit(:first_name, :last_name, :family_id, :date_of_birth, :rating, :active)
    end
end
