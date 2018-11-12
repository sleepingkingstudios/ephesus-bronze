# frozen_string_literal: true

require 'patina/collections/simple/repository'

require 'ephesus/bronze/applications'

module Ephesus::Bronze::Applications
  # Helper module that defines a repository for Ephesus applications.
  module Repository
    def initialize(repository: nil, state: nil)
      super(state: state)

      @repository = repository || build_repository
    end

    attr_reader :repository

    private

    def build_repository
      Patina::Collections::Simple::Repository.new
    end
  end
end
