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
        @today_shifts = Shift.for_store(mgr_store).for_next_days(0)
        @next_weeks_shifts = Shift.for_store(mgr_store).for_next_days(7)
    elsif current_user && current_user.role?(:employee)
        @flavors = StoreFlavor.paginate(page: params[:page]).per_page(10)
    end
  end

  def about
  end

  def privacy
  end

  def contact
  end

end