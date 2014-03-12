class Town
  include Diametric::Entity
  include Diametric::Persistence::Peer
  
  def self.states
    # Returns an array of ["State Name", "State Abbrev"]
    IO.readlines("#{ROOT}/models/state_list").map { |line| line.chomp.split(',') }
  end

  attribute :name, String, index: true
  attribute :state, String
  validates :state, inclusion: { in: self.states.map(&:second) }
end
Town.create_schema.get
