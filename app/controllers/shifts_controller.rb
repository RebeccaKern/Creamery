class ShiftsController < ApplicationController
  before_action :set_shift, only: [:show, :edit, :update, :destroy, :start_shift, :end_shift]
  authorize_resource

  def index
    @current_shifts = Shift.upcoming.by_employee.paginate(page: params[:page]).per_page(8)
  end

  def show
    @current_shifts = Shift.upcoming.by_employee.paginate(page: params[:page]).per_page(8)
  end

  def new
    @shift = Shift.new
  end

  def edit
  end

  def create
    @shift = Shift.new(shift_params)
    if @shift.save
      respond_to do |format|
        format.html {redirect_to shift_path(@shift), notice: "Successfully created shift for #{@shift.assignment.employee.name}."}
        mgr_store = current_user.employee.current_assignment.store
        @next_weeks_shifts = Shift.for_store(mgr_store).for_next_days(7)
        format.js
      end
    else
      render action: 'new'
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
  def set_shift
    @shift = Shift.find(params[:id])
  end

  def shift_params
    params.require(:shift).permit(:date, :assignment_id, :start_time, :end_time, :notes, :job_ids => [])
  end

end