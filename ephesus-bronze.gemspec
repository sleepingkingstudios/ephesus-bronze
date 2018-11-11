# frozen_string_literal: true

$LOAD_PATH << './lib'

require 'ephesus/bronze/version'

Gem::Specification.new do |gem| # rubocop:disable Metrics/BlockLength
  gem.name        = 'ephesus-bronze'
  gem.version     = Ephesus::Bronze::VERSION
  gem.date        = Time.now.utc.strftime '%Y-%m-%d'
  gem.summary     = 'Bronze integration for Ephesus applications.'

  description = <<~DESCRIPTION
    Ephesus integration with the Bronze application toolkit.
  DESCRIPTION
  gem.description = description.strip.gsub(/\n +/, ' ')
  gem.authors     = ['Rob "Merlin" Smith']
  gem.email       = ['merlin@sleepingkingstudios.com']
  gem.homepage    = 'http://sleepingkingstudios.com'
  gem.license     = 'GPL-3.0'

  gem.require_path = 'lib'
  gem.files        = Dir['lib/**/*.rb', 'LICENSE', '*.md']

  gem.add_runtime_dependency 'sleeping_king_studios-tools', '~> 0.7'
end
