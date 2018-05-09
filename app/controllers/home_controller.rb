class HomeController < ApplicationController
  include AppHelpers::Cart
  def index

  	@reg = Camp.upcoming.map{|c| c.enrollment}.to_a.first(5)
  	@curric = Curriculum.all.map{|c| c.name}.to_a
  	@all_curric = Curriculum.all

  	@reg_count = []
  	@all_curric.each{ |curric|
  		count = 0
  		c_camps = curric.camps.to_a
  		c_camps.each{|cc|
  			count += cc.enrollment}
  		@reg_count.push(count)
  	}


  	# @reg_count = Curriculum.all.map{|c| c.camps.upcoming.map{|cmp| cmp.enrollment}}.flatten.to_a
  	@camps = Camp.upcoming.map{|c| c.name}.to_a.first(5)



    @regcount = Registration.all.count
    @stucount = Student.active.count
    @famcount = Family.active.count
    @instrucount = Instructor.active.count

    @camp_sort = Camp.active.sort_by {|f| f.students.count}.reverse.first(10)
    @campps = @camp_sort.map{|f| f.name}.to_a
    @campstds = []
    @camp_sort.each{ |c|

      @campstds.push(c.students.size.round)
    }


    #parent
    @random = Camp.all.sample(3).to_a
    if logged_in? && current_user.role?(:parent)
      @studs = current_user.family.students.to_a


    end



  end



  def about
  end

  def contact
  end

  def privacy
  end

end
