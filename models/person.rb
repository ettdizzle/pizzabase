class Person
  include Diametric::Entity
  include Diametric::Persistence::Peer
  attribute :name, String, index: true
  attribute :birthday, DateTime
  attribute :awesomeness, Boolean, doc: "Is this person awesome?"
  attribute :hometown, Ref, :cardinality => :one
end
Person.create_schema.get
