module Api
  module V1
    class LookupsController < ApplicationController
      before_action :authorize_access_request! 
      before_action :set_lookup, only: [:show, :update, :destroy]

      # GET /lookups
      def index
        @lookups = current_user.lookups.all

        render json: @lookups
      end

      # GET /lookups/1
      def show
        render json: @lookup
      end

      # POST /lookups
      def create
        @lookup = current_user.lookups.build(lookup_params)

        if @lookup.save
          render json: @lookup, status: :created
        else
          render json: @lookup.errors, status: :unprocessable_entity
        end
      end

      # PATCH/PUT /lookups/1
      def update
        if @lookup.update(lookup_params)
          render json: @lookup
        else
          render json: @lookup.errors, status: :unprocessable_entity
        end
      end

      # DELETE /lookups/1
      def destroy
        @lookup.destroy
      end

      private
        # Use callbacks to share common setup or constraints between actions.
        def set_lookup
          @lookup = current_user.lookups.find(params[:id])
        end

        # Only allow a trusted parameter "white list" through.
        def lookup_params
          params.require(:lookup).permit(:search, :user_id)
        end
    end
  end
end
