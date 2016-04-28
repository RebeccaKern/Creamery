class EmployeesController < ApplicationController
  before_action :set_employee, only: [:show, :edit, :update, :destroy]
  authorize_resource
  
  def index
    if current_user && current_user.role?(:admin)
      @active_employees = Employee.active.alphabetical.paginate(page: params[:page]).per_page(10)
      @inactive_employees = Employee.inactive.alphabetical.paginate(page: params[:page]).per_page(10)
    elsif current_user && current_user.role?(:manager)
      mgr_store = current_user.employee.current_assignment.store
      #@assignments = mgr_store.assignments.current.paginate(page: params[:page]).per_page(10)
      #@active_employees = []
      @active_employees = Employee.by_store(mgr_store).paginate(page: params[:page]).per_page(10)
      #@assignments.map{|a| a.employee}
      @inactive_employees = []
    # elsif current_user && current_user.role?(:employee)
    #    @active_employees = []#current_user.employee
    #    @inactive_employees = []
    else
      @active_employees = []
      @inactive_employees = [] 
    end

  end

  def show
    # get the assignment history for this employee
    @assignments = @employee.assignments.chronological.paginate(page: params[:page]).per_page(5)
    # get upcoming shifts for this employee (later)  
  end

  def new
    @employee = Employee.new
    user = @employee.build_user
  end

  def edit
    # fix so that you edit somebody that doesn't have a user
  end

  def create
    @employee = Employee.new(employee_params)
    if @employee.save
      user = User.new(user_params)
      user.employee_id = @employee.id
      user.save!
      redirect_to employee_path(@employee), notice: "Successfully created #{@employee.proper_name}."
    else
      render action: 'new'
    end
  end

  def update
    if @employee.update(employee_params)
      redirect_to employee_path(@employee), notice: "Successfully updated #{@employee.proper_name}."
    else
      render action: 'edit'
    end
  end

  def destroy
    @employee.destroy
    redirect_to employees_path, notice: "Successfully removed #{@employee.proper_name} from the AMC system."
  end

  private
  def set_employee
    @employee = Employee.find(params[:id])
  end

  def employee_params
    params.require(:employee).permit(:first_name, :last_name, :ssn, :date_of_birth, :role, :phone, :active, user_attributes: [:id, :email, :password, :password_confirmation])
  end

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :employee_id)
  end
end