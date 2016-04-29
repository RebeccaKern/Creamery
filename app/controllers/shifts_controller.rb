class ShiftsController < ApplicationController
  before_action :set_shift, only: [:show, :edit, :update, :destroy, :start_shift, :end_shift]
  authorize_resource

  def index
    @current_shifts = Shift.upcoming.by_employee.paginate(page: params[:page]).per_page(8)
  end

  def show
    @current_shifts = @shift.upcoming.by_employee.paginate(page: params[:page]).per_page(8)
  end

  def new
    @shift = Shift.new
  end

  def edit
  end

  def create
    @shift = Shift.new(shift_params)
    
    if @shift.save
      redirect_to shift_path(@shift), notice: "Successfully created #{@shift.name}."
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
  end

  def end_shift
    @shift.end_now
  end

  private
  def set_shift
    @shift = Shift.find(params[:id])
  end

  def shift_params
    params.require(:shift).permit(:date, :assignment_id, :start_time, :notes, :job_ids => [])
  end

end