class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    if user.role? :admin
        can :manage, :all

    elsif user.role? :manager
        can :read, Store
        can :read, Flavor
        can :read, Job

      can :index, Employee do |this_employee|
        mgr_store = user.employee.current_assignment.store
        current_employees = mgr_store.assignments.current.map{|a| a.employee}
        current_employees.include?(this_employee)
      end 

      can :show, Employee do |this_employee|
        mgr_store = user.employee.current_assignment.store
        current_employees = mgr_store.assignments.current.map{|a| a.employee}
        current_employees.include?(this_employee)
      end 

      can :index, Assignment
      
      can :show, Assignment do |this_assignment|
        mgr_store = user.employee.current_assignment.store
        store_assignments = mgr_store.assignments.current.map{|a| a}
        store_assignments.include?(this_assignment)
      end 

      can :index, Shift
      
      can :show, Shift do |this_shift|
        mgr_store = user.employee.current_assignment.store
        store_shifts = Shift.all.map{|s| s if s.store == mgr_store}
        store_shifts.include?(this_shift)      
      end 

      #can :manage, Shift
      # can create shifts for their employees
      can :create, Shift do |this_shift|
        mgr_store = user.employee.current_assignment.store
        store_shifts = Shift.all.map{|s| s if s.store == mgr_store}
        store_shifts.include?(this_shift)
      end

      can :update, Shift do |this_shift|
        mgr_store = user.employee.current_assignment.store
        store_shifts = Shift.all.map{|s| s if s.store == mgr_store}
        store_shifts.include?(this_shift)
      end

      can :destroy, Shift do |this_shift|
        mgr_store = user.employee.current_assignment.store
        store_shifts = Shift.all.map{|s| s if s.store == mgr_store}
        store_shifts.include?(this_shift)
      end

      can :start_shift, Shift do |this_shift|
        mgr_store = user.employee.current_assignment.store
        store_shifts = Shift.all.map{|s| s if s.store == mgr_store}
        store_shifts.include?(this_shift)
      end

      can :end_shift, Shift do |this_shift|
        mgr_store = user.employee.current_assignment.store
        store_shifts = Shift.all.map{|s| s if s.store == mgr_store}
        store_shifts.include?(this_shift)
      end

      can :manage, ShiftJob

      can :update, ShiftJob do |this_sj|
        mgr_store = user.employee.current_assignment.store
        store_assignments = mgr_store.assignments.current.map{|a| a}
        store_shifts = store_assignments.map{|s| s.shifts}
        store_shift_jobs = store_shifts.map{|s| s.shift_jobs }
        store_shift_jobs.include? this_sj
      end

      can :destroy, ShiftJob do |this_sj|
        mgr_store = user.employee.current_assignment.store
        store_assignments = mgr_store.assignments.current.map{|a| a}
        store_shifts = store_assignments.map{|s| s.shifts}
        store_shift_jobs = store_shifts.map{|s| s.shift_jobs }
        store_shift_jobs.include? this_sj
      end

      can :toggle, StoreFlavor do |this_sf|
        mgr_store = user.employee.current_assignment.store
        store_store_flavors = mgr_store.store_flavors.map{|a| a}
        store_store_flavors.include? this_sf
      end

    elsif user.role? :employee
      can :read, Store
      can :read, Job 
      can :read, Flavor

      # only for them individually
      can :read, Employee do |e|
        e.id == user.employee_id
      end

      can :update, Employee do |e|
        e.id == user.employee_id
      end

      can :read, User do |u|  
        u.id == user.id
      end

      can :update, User do |u|  
        u.id == user.id
      end

      can :read, Assignment do |a|
        a.id == user.employee.assignment_id
      end

      can :read, Shift do |this_shift|  
        my_shifts = user.employee.shifts.map(&:id)
        my_shifts.include? this_shift.id 
      end

      # start their shift and end their shift
      can :update, Shift do |shift|  
        employee_shifts = user.employee.shifts.map(&:id)
        employee_shifts.include? shift.id 
      end

      can :manage, Shift

    else
      # guests can only read domains covered (plus home pages)
      can :read, Store do |this_store|
        active_stores = Store.active.map(&:id)
        active_stores.include? this_store.id
      end

      #can :read, Flavor
    end

  end
end
      
    