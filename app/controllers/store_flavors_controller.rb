 class StoreFlavorsController < ApplicationController
    before_action :set_store_flavor, only: [:destroy]
    authorize_resource

    def new
      @store_flavor = StoreFlavor.new
    end

    def create
      @store_flavor = StoreFlavor.new(store_flavor_params)
      @store_flavor.save!
    end

    def destroy
      @store_flavor.destroy
    end

    private
      def set_store_flavor
        @store_flavor = StoreFlavor.find(params[:id])
      end

      def store_flavor_params
        params.require(:store_flavor).permit(:store_id, :flavor_id)
      end
  end