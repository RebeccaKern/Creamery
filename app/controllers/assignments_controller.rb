class AssignmentsController < ApplicationController
  before_action :set_assignment, only: [:edit, :update, :destroy]
  # before_action :set_assignment, only: [:show, :edit, :update, :destroy]
  
  authorize_resource
  # def index
  #   @current_assignments = Assignment.current.by_store.by_employee.chronological.paginate(page: params[:page]).per_page(15)
  #   @past_assignments = Assignment.past.by_employee.by_store.paginate(page: params[:page]).per_page(15)  
  # end

  def index
    if current_user && current_user.role?(:admin)
      @current_assignments = Assignment.current.by_store.by_employee.chronological.paginate(page: params[:page]).per_page(15)
      @past_assignments = Assignment.past.by_employee.by_store.paginate(page: params[:page]).per_page(15)  
    elsif current_user && current_user.role?(:manager)
      mgr_store = current_user.employee.current_assignment.store
      @current_assignments = mgr_store.assignments.current.paginate(page: params[:page]).per_page(10)
      @past_assignments = []
    elsif current_user && current_user.role?(:employee)
      @current_assignments = Assignment.for_employee(current_user.employee).current.paginate(page: params[:page]).per_page(10)
      @past_assignments = Assignment.for_employee(current_user.employee).past.paginate(page: params[:page]).per_page(10)
    else
      @current_assignments = []#Employee.active.alphabetical.paginate(page: params[:page]).per_page(10)#[] #Employee.active.alphabetical.paginate(page: params[:page]).per_page(10)
      @past_assignments = [] #Employee.inactive.alphabetical.paginate(page: params[:page]).per_page(10)
    end
  end

  # def show
  #   # get the shift history for this assignment (later; empty now)
  #   @shifts = Array.new
  # end

  def new
    @assignment = Assignment.new
    # if params[:from].nil?
    #   if params[:id].nil?
    #     @assignment = Assignment.new
    #   else
    #     @assignment = Assignment.find(params[:id])
    #   end
    # else
    #   @assignment = Assignment.new
    #   if params[:from] == "store" 
    #     @assignment.store_id = params[:id]
    #   else
    #     @assignment.employee_id = params[:id]
    #   end
    # end
  end

  def edit
  end

  def create
    @assignment = Assignment.new(assignment_params)
    
    if @assignment.save
      redirect_to assignments_path, notice: "#{@assignment.employee.proper_name} is assigned to #{@assignment.store.name}."
      # redirect_to assignment_path(@assignment), notice: "#{@assignment.employee.proper_name} is assigned to #{@assignment.store.name}."
    else
      render action: 'new'
    end
  end

  def update
    if @assignment.update(assignment_params)
      redirect_to assignments_path, notice: "#{@assignment.employee.proper_name}'s assignment to #{@assignment.store.name} is updated."
    else
      render action: 'edit'
    end
  end

  def destroy
    @assignment.destroy
    redirect_to assignments_path, notice: "Successfully removed #{@assignment.employee.proper_name} from #{@assignment.store.name}."
  end

  private
  def set_assignment
    @assignment = Assignment.find(params[:id])
  end

  def assignment_params
    params.require(:assignment).permit(:employee_id, :store_id, :start_date, :end_date, :pay_level)
  end

end