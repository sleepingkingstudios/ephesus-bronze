# frozen_string_literal: true

require 'ephesus/bronze/commands'

module Ephesus::Bronze::Commands
  # Helper module that defines a repository for Ephesus commands.
  module Repository
    def repository
      options.fetch(:repository)
    end
  end
end
