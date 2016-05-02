 class ShiftJobsController < ApplicationController
    before_action :set_shift_job, only: [:destroy]
    authorize_resource

    def new
      @shift_job = ShiftJob.new
    end

    def create
      @shift_job = ShiftJob.new(shift_job_params)
      @shift_job.save!
    end

    def destroy
      @shift_job.destroy
    end

    def toggle
      job_id = params[:job_id]
      shift_id = params[:shift_id]
      if params[:status] == 'add'
          sj = ShiftJob.new
          sj.shift_id = shift_id
          sj.job_id = job_id
          sj.save!
      else
        sj = ShiftJob.find_by_shift_id_and_job_id(shift_id, job_id)
        sj.destroy
      end
      respond_to do |format|
        @jobs = Job.alphabetical
        @shift_jobs = ShiftJob.all
        format.js
      end
    end

    private
      def set_store_flavor
        @shift_job = ShiftJob.find(params[:id])
      end

      def store_flavor_params
        params.require(:shift_job).permit(:shift_id, :job_id)
      end
  end