class ShiftsController < ApplicationController
  before_action :set_shift, only: [:show, :edit, :update, :destroy]

  def show
    @current_shifts = @shift.upcoming.by_employee.paginate(page: params[:page]).per_page(8)
  end

  def new
    authorize! :new, @shift
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
      redirect_to shift_path(@shift), notice: "Successfully updated #{@shift.name}."
    else
      render action: 'edit'
    end
    authorize! :update, @shift
  end

  def destroy
    @shift.destroy
    redirect_to shifts_path, notice: "Successfully removed #{@shift.name} from the AMC system."
    authorize! :destroy, @shift
  end

  private
  def set_shift
    @shift = shift.find(params[:id])
  end

  def shift_params
    params.require(:shift).permit(:date, :assignment_id, :start_time, :notes)
  end

end