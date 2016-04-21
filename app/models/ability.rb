class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    if user.role? :admin
        can :manage, :all

    elsif user.role? :manager
      # can see a list of their employees
      # can edit employee information
      # can see a list of their shifts
      # can update shifts in the system
      # can see a list of the store flavors
      # can update a list of their flavors
      # edit store data

      # can read their employee profiles
      can :read, Employee do |this_employee|
        managed_employees = user.employees.map{|e| e.id if e.store_id == user.store.id}
        managed_employees.include? this_project.id
      end 

      # they can update their employee profiles
      can :update, User do |u|  
        managed_employees = user.employees.map{|e| e.id if e.store_id == user.store.id}
        managed_employees.include? this_project.id
      end
      
      # they can read shifts for their store
      can :read, Shift do |this_shift|  
        store_shifts = user.shifts.map(&:id)
        store_shifts.include? this_shift.id 
      end

      # can update shifts for their store
      can :update, Shift do |this_shift|
        managed_shifts = user.employee.assignment.store.shifts.map{|s| s.id if s.store_id == user.store_id}
        managed_shifts.include? this_shift.id
      end

      # can create shifts for their store
      can :create, Shift

      # they can read flavors
      can :read, Flavor

      # can update flavors for their store
      can :update, Flavor do |this_flavor|
        managed_flavors = user.employee.assignment.store.flavors.map{|s| s.id if s.store_flavor.store_id == user.store_id}
        managed_flavors.include? this_flavor.id
      end

      # can create flavors for their store
      can :create, Flavor

      can :read, Job 

    elsif user.role? :employee
      # see their personal information

      # they can read their own profile
      can :show, User do |u|  
        u.id == user.id
      end

      # see worked shifts and jobs and future shifts
      can :read, Shift do |this_shift|  
        my_shifts = user.employee.shifts.map(&:id)
        my_shifts.include? this_shift.id 
      end

      can :read, Job 

      # start their shift and end their shift
      can :update, Shift do |shift|  
        employee_shifts = user.employee.shifts.map(&:id)
        employee_shifts.include? shift.id 
      end

    else
      # guests can only read domains covered (plus home pages)
      #can :read, Store
      #can :read, Flavor
    end

  end
end
      
    