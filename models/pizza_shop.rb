class PizzaShop
  include Diametric::Entity
  include Diametric::Persistence::Peer
  attribute :name, String, index: true
  attribute :location, Ref, :cardinality => :one
  attribute :quality, String
  validates :quality, inclusion: { in: %w(poor serviceable decent good excellent) }
  attribute :phone, String
  validates :phone, format: { with: /^\d{3}.\d{3}.\d{4}$/, message: "Phone number must be ###-###-####" }
end
PizzaShop.create_schema.get
