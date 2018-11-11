# Gemfile

source 'https://rubygems.org'

gemspec

def component(name)
  if ENV['CI']
    gem "ephesus-#{name}",
      git: "https://github.com/sleepingkingstudios/ephesus-#{name}"
  else
    gem "ephesus-#{name}", path: "../#{name}"
  end
end

gem 'bronze',
  git: 'https://github.com/sleepingkingstudios/bronze',
  branch: 'chore/update-cuprum'

gem 'cuprum', git: 'https://github.com/sleepingkingstudios/cuprum'

gem 'patina',
  git: 'https://github.com/sleepingkingstudios/bronze',
  branch: 'chore/update-cuprum'

gem 'zinke', git: 'https://github.com/sleepingkingstudios/zinke'

component :core

group :development, :test do
  gem 'byebug', '~> 9.0', '~> 9.0.5'
end
