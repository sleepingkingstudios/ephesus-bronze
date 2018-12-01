# frozen_string_literal: true

require 'ephesus/bronze/entities'

module Ephesus::Bronze::Entities
  # Helper methods to convert Bronze entities into immutable data objects.
  module Immutable
    def to_immutable(include: nil)
      hsh = Hamster::Hash.new(attributes)

      associations = Array(include).compact

      return hsh if associations.empty?

      associations.reduce(hsh) do |memo, name|
        memo.put(name.intern) { association_to_immutable(name) }
      end
    end

    private

    def association_to_immutable(name)
      value = send(name)

      return nil if value.nil?
      return entity_to_immutable(value) unless value.respond_to?(:each)

      Hamster::Vector.new(
        value.map { |entity| entity_to_immutable(entity) }
      )
    end

    def entity_to_immutable(entity)
      return entity.to_immutable if entity.respond_to?(:to_immutable)

      Hamster::Hash.new(entity.attributes)
    end
  end
end
