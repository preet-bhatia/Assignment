class SaveAddress
    attr_reader :account_number

    def self.call(args)
        byebug
        service = self.new(args)
        service.assign_address
    end
    
    def initialize(args)
        @address1 = args[:address1]
        @district = args[:district]
        @state = args[:state]
        @country = args[:country]
        @postal_code = args[:postal_code]
        @customer_id = args[:customer_id]
    end

    def assign_address
        Address.create(address1:@address1, district:@district, state:@state, country:@country, postal_code:@postal_code, customer_id:@customer_id)
    end
end