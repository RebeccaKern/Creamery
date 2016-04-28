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

    def toggle
      flavor_id = params[:flavor_id]
      store_id = current_user.employee.current_assignment.store.id
      if params[:status] == 'add'
          sf = StoreFlavor.new
          sf.store_id = store_id
          sf.flavor_id = flavor_id
          sf.save!
      else
        sf = StoreFlavor.find_by_store_id_and_flavor_id(store_id, flavor_id)
        sf.destroy
      end
      respond_to do |format|
        mgr_store = current_user.employee.current_assignment.store
        @flavors = Flavor.alphabetical
        @mgr_store_flavors = StoreFlavor.by_store(mgr_store).map{|sf| sf.flavor}
        format.js
      end
    end

    private
      def set_store_flavor
        @store_flavor = StoreFlavor.find(params[:id])
      end

      def store_flavor_params
        params.require(:store_flavor).permit(:store_id, :flavor_id)
      end
  end