 class ShiftJobsController < ApplicationController
    #before_action :set_shift_job, only: [:destroy]
    authorize_resource

    def new
      @shift_job = ShiftJob.new
    end

    def create
      @shift_job = ShiftJob.new(shift_job_params)
      @shift_job.save!
    end

    def destroy(id)
      @shift_job = ShiftJob.find_by(id)
      @shift_job.destroy
    end

    def toggle
      job_id = params[:job_id]
      shift_id = params[:shift_id]
      sj = ShiftJob.find_by(shift_id: shift_id, job_id: job_id)
        
      if sj.nil?
          sjj = ShiftJob.new
          sjj.shift_id = shift_id
          sjj.job_id = job_id
          sjj.save!
      else
        sj.destroy
      end
      respond_to do |format|
        mgr_store = current_user.employee.current_assignment.store
        @jobs = Job.alphabetical
        @shift = Shift.find(params[:shift_id])
        #@shift_jobs = ShiftJob.all
        @past_shifts = Shift.for_store(mgr_store).past.paginate(page: params[:page]).per_page(5)
        @complete_shifts = Shift.for_store(mgr_store).incomplete
        format.js
      end
    end

    private
      # def set_shift_job
      #   @shift_job = ShiftJob.find(params[:id])
      # end

      def shift_job_params
        params.require(:shift_job).permit(:shift_id, :job_id)
      end
  end