# frozen_string_literal: true

require 'forwardable'

require 'ephesus/bronze/sessions'

module Ephesus::Bronze::Sessions
  # Helper module that defines a repository for Ephesus sessions.
  module Repository
    extend Forwardable

    def_delegators :@application, :repository

    private

    def controller_options
      super.merge repository: repository
    end
  end
end
