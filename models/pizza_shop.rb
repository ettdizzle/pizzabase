class PizzaShop
  include Diametric::Entity
  include Diametric::Persistence::Peer
  
  # Use for validations and options in view
  def self.quality_options
    %w(poor serviceable decent good excellent)
  end

  attribute :name, String, index: true
  attribute :location, Ref, :cardinality => :one
  attribute :quality, String
  validates :quality, inclusion: { in: self.quality_options }
  attribute :phone, String
  validates :phone, format: { with: /^\d{3}.\d{3}.\d{4}$/, message: "Phone number must be ###-###-####" }, :allow_blank => true
end
PizzaShop.create_schema.get
