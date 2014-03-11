class Town
  include Diametric::Entity
  include Diametric::Persistence::Peer
  attribute :name, String, index: true
  attribute :state, String
end
Town.create_schema.get
