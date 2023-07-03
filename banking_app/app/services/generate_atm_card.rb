class GenerateAtmCard
    attr_reader :account_number

    def self.call(args)
        service = self.new(args)
        service.create_card_attributes
    end
    
    def initialize(args)
        @account_number = args[:account_number]
    end

    def create_card_attributes
        card = AtmCard.create(card_number:generate_card_number, cvv: generate_cvv, expiry_date: generate_expiry_date, account_number: @account_number)
    end

    def generate_cvv
        rand(100...999)
    end
    
    def generate_card_number
        token = ''
        16.times { token += rand(0..9).to_s}
        token
    end
    
    def generate_expiry_date
        t = Time.now + 5.year
        t.strftime("%m/%y")
    end
    
end