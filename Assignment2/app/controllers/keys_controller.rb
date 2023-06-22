class KeysController < ApplicationController

    def new
        @key = Key.generate_new_key
    end

    def unblock
        @key = Key.find_by_id(params[:id])
        @key.set_status(:free) if @key
    end

    def destroy
        @key = Key.find_by_id(params[:id])
        @key.delete_key if @key
    end

    def available
        @key = Key.find_by( status: :free )
        @key.set_status(:blocked) if @key
    end

    def alive
        @key = Key.find_by_id(params[:id])
        @key.keep_alive if @key
    end
end