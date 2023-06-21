class KeysController < ApplicationController
    @@is_running = false
    after_action :background_job, only: [:new]

    def new
        @key = Key.generate_new_key
    end

    def unblock
        @key = Key.find_by_id(params[:id])
        @key.set_status("FREE") if @key
    end

    def destroy
        @key = Key.find_by_id(params[:id])
        @key.delete_key if @key
    end

    def available
        @key = Key.find_by( status: "FREE" )
        @key.set_status("BLOCKED") if @key
    end

    def alive
        @key = Key.find_by_id(params[:id])
        @key.keep_alive if @key
    end

    private
    def background_job
        if !@@is_running
            CleanupTaskJob.perform_later
            @@is_running = true
        end
    end
end