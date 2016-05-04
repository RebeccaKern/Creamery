class ShiftsController < ApplicationController
  before_action :set_shift, only: [:show, :edit, :update, :destroy, :start_shift, :end_shift]
  authorize_resource


  def index
    if current_user && current_user.role?(:admin)
      @current_shifts = Shift.upcoming.by_employee.paginate(page: params[:page]).per_page(8)
    elsif current_user && current_user.role?(:manager)
      mgr_store = current_user.employee.current_assignment.store
      @current_shifts = Shift.for_store(mgr_store).paginate(page: params[:page]).per_page(8)
    elsif current_user && current_user.role?(:employee)
      @current_shifts = Shift.for_employee(current_user.employee).paginate(page: params[:page]).per_page(10)
    end
  end

  def show
    @current_shifts = Shift.upcoming.by_employee.paginate(page: params[:page]).per_page(8)
  end

  # def incomplete
  #   @incomplete_shifts = Shift.for_store(mgr_store).incomplete
  # end

  def new
    @shift = Shift.new
  end

  def edit
  end

  def create
    @shift = Shift.new(shift_params)
    puts params
    puts params[:status]
    if @shift.save && params[:status] == 'finish'
      #redirect_to assignments_path, notice: "#{@assignment.employee.proper_name} is assigned to #{@assignment.store.name}."
      redirect_to shift_path(@shift), notice: "Successfully created shift for #{@shift.assignment.employee.name}.}"
      # respond_to do |format|
      #   format.html {redirect_to shift_path(@shift), notice: "Successfully created shift for #{@shift.assignment.employee.name}."}
      #   mgr_store = current_user.employee.current_assignment.store
      #   @next_weeks_shifts = Shift.for_store(mgr_store).for_next_days(7)
      #   format.js
      # end
    elsif @shift.save && params[:status] == 'add_another'
      render :partial => 'new_shift_form', notice: "Successfully created shift for #{@shift.assignment.employee.name}.}"
      # respond_to do |format|
      #   format.html {redirect_to new_shift_path, notice: "Successfully created shift for #{@shift.assignment.employee.name}."}
      #   mgr_store = current_user.employee.current_assignment.store
      #   @next_weeks_shifts = Shift.for_store(mgr_store).for_next_days(7)
      #   format.js
      # end
    # else
    #   render action: 'new'
    end

  end

  def update
    if @shift.update(shift_params)
      redirect_to shift_path(@shift), notice: "Successfully updated #{@shift.employee.name}'s shift."
    else
      render action: 'edit'
    end
  end

  def destroy
    @shift.destroy
    redirect_to shifts_path, notice: "Successfully removed #{@shift.employee.name}'s shift from the AMC system."
  end

  #start now and end now routes associated and then call the model
  def start_shift
    @shift.start_now
    redirect_to home_url, notice: "started shift"
  end

  def end_shift
    @shift.end_now
    redirect_to home_url, notice: "ended shift"
  end

  private
    def convert_start_date
      params[:shift][:date] = (params[:shift][:date]).to_date unless params[:shift][:date].blank?
    end

  def set_shift
      @shift = Shift.find(params[:id])
  end

  def shift_params
    convert_start_date
    params.require(:shift).permit(:date, :assignment_id, :start_time, :end_time, :notes, :job_ids => [])
  end

end