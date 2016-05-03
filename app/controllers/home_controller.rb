class HomeController < ApplicationController

  def home
    if current_user && current_user.role?(:admin)
        @active_stores = Store.active.alphabetical.paginate(page: params[:page]).per_page(10)
        @inactive_stores = Store.inactive.alphabetical.paginate(page: params[:page]).per_page(10)  
    elsif current_user && current_user.role?(:manager)
        mgr_store = current_user.employee.current_assignment.store
        @active_employees = Employee.by_store(mgr_store).paginate(page: params[:page]).per_page(10)
        @inactive_employees = []
        @flavors = Flavor.alphabetical
        @mgr_store_flavors = StoreFlavor.by_store(mgr_store).map{|sf| sf.flavor}
        @shift_jobs = ShiftJob.all
        @today_shifts = Shift.for_store(mgr_store).for_next_days(0)
        @next_weeks_shifts = Shift.for_store(mgr_store).for_next_days(7)
        @past_shifts = Shift.for_store(mgr_store).past.paginate(page: params[:page]).per_page(5)
        @incomplete_shifts = Shift.for_store(mgr_store).incomplete.paginate(page: params[:page]).per_page(5)
        @complete_shifts = Shift.for_store(mgr_store).completed
        @jobs = Job.alphabetical
    elsif current_user && current_user.role?(:employee)
        @flavors = StoreFlavor.paginate(page: params[:page]).per_page(10)
        @my_upcoming_shifts = Shift.for_employee(current_user.employee).upcoming.paginate(page: params[:page]).per_page(10)
        @last_week_shifts = Shift.for_employee(current_user.employee).for_past_days(7).paginate(page: params[:page]).per_page(10)
    end
  end

  def about
  end

  def privacy
  end

  def contact
  end

end