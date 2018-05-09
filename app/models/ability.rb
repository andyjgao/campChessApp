class Ability
  include CanCan::Ability

  def initialize(user)
    # set user to new User if not logged in
    user ||= User.new # i.e., a guest user

    # set authorizations for different user roles
    if user.role? :admin
      # they get to do it all
      can :manage, :all

    elsif user.role? :instructor
      # can read curriculum, location, and Camp
        can :read, Curriculum
        can :read, Location
        can :read, Camp


        # 2. can edit their bio and picture, as well as email and phone, but not those
        # of other instructors.

        # #can edit their own Instructor profile
        can :update, Instructor do |i|
          user.instructor == i
        end
        can :show, Instructor do |i|
          user.instructor == i
        end

        #can edit their own User profile
        can :update, User do |u|
          u.id == user.id
        end
        can :show, User do |u|
          u.id == user.id
        end

        can :read, Student do |this_student|
          my_students = user.instructor.students.map(&:id)
          my_students.include? this_student.id
        end
        can :read, Family do |this_family|
          my_students = user.instructor.students.map(&:family_id)
          my_students.include? this_family.id
        end

    elsif user.role? :parent

      can :manage, User do |u|
        u.id == user.id
      end

      can :manage, Family do |f|
        f.id == user.family.id
      end

      can :read, Curriculum
      can :read, Location #???
      can :read, Camp

      can :manage, Student do |s|
        s.family.id == user.family.id
      end



      can :create, Registration do |r|
        r.student.family.id == user.id
      end

      can :edit, Registration do |r|
        r.payment = nil
      end

    else

      can :read, Curriculum
      can :read, Location
      can :read, Camp

      can :create, User
      can :create, Family

    end
  end
end
