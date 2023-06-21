class Key < ApplicationRecord

    def self.generate_new_key
        token = SecureRandom.hex(5)
        key = Key.create( key_id:token, status:"FREE", last_alive_at: Time.now, timestamp: Time.now) 
    end

    def self.find_by_id(id)
        Key.find_by(key_id: id)
    end

    def set_status(status)
        self.status = status
        self.timestamp = Time.now
        self.save
    end

    def delete_key
        self.destroy
    end

    def keep_alive
        self.last_alive_at = Time.now
        self.save
    end

end