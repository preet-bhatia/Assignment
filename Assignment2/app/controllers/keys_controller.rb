class KeysController < ApplicationController
    before_action :background_task, only: [:new]
    
    def new
        token = SecureRandom.hex(5)
        @key = Key.create( key_id:token, status:"FREE", last_alive_at: Time.now, timestamp: Time.now)
    end

    def unblock
        @key = Key.find_by( key_id:params[:id] )
        if @key
            set_status(@key, "FREE")
        end
    end

    def destroy
        @key = Key.find_by( key_id:params[:id] )
        if @key
            delete_key(@key)
        end
    end

    def available
        @key = Key.find_by( status: "FREE" )
        if @key
            set_status(@key, "BLOCKED")
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

    def delete_key(key)
        key.destroy
    end

    def set_status(key, new_status)
        key.status = new_status
        key.timestamp = Time.now
        key.save
    end

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
                set_status(key, "FREE")
            elsif Time.now - key.last_alive_at > 300
                delete_key(key)
            end
        end
    end
end