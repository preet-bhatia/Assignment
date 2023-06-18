class KeysController < ApplicationController
    before_action :background_task, only: [:new]
    
    def new
        token = SecureRandom.hex(5)
        @key = Key.new( key_id:token, status:"FREE", last_alive_at: Time.now, timestamp: Time.now)
        @key.save
    end

    def unblock
        @key = Key.find_by( key_id:params[:id] )
        if @key
            @key.status = "FREE"
            @key.timestamp = Time.now
            @key.save
        end
    end

    def destroy
        @key = Key.find_by( key_id:params[:id] )
        if @key
            @key.destroy
        end
    end

    def available
        @key = Key.find_by( status: "FREE" )
        if @key
            @key.status = "BLOCKED"
            @key.timestamp = Time.now
            @key.save
        end
    end

    def alive
        @key = Key.find_by( key_id:params[:id] )
        if @key
            @key.last_alive_at = Time.now
            @key.save
        end
    end
    
    private

    def background_task
        Thread.new do
            loop do
                sleep 1
                update_keys
            end
        end
    end

    def update_keys
        keys = Key.all
        keys.each do |key|
            if key.status == "BLOCKED" && Time.now - key.timestamp > 60
                key.status = "FREE"
                key.save
            elsif Time.now - key.last_alive_at > 300
                key.destroy
            end
        end
    end
end