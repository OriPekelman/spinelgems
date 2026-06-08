require "zz_provider"
module AaConsumer
  # references the dependency's constant AT LOAD TIME — fails if zz_provider
  # hasn't been loaded first (the topo-order test, spinelgems#19).
  DOUBLED = ZzProvider::VALUE * 2
  def self.report = "consumer sees #{DOUBLED}"
end
