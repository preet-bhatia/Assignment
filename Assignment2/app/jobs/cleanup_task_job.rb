class CleanupTaskJob < ApplicationJob
    def perform
        loop do
            update_keys
            sleep 5
        end
    end

    def update_keys
        keys = Key.all
        keys.each do |key|
            if key.status == "blocked" && Time.now - key.timestamp > 60
                key.set_status(:free)
            elsif Time.now - key.last_alive_at > 300
                key.delete_key
            end
        end
    end
end