# frozen_string_literal: true

require 'ephesus/bronze/applications/repository'
require 'ephesus/bronze/commands/repository'
require 'ephesus/bronze/sessions/repository'
require 'ephesus/core/application'
require 'ephesus/core/command'
require 'ephesus/core/controller'
require 'ephesus/core/session'

RSpec.describe Ephesus::Bronze::Sessions::Repository do
  subject(:instance) { described_class.new(application) }

  let(:described_class) { Spec::ExampleSession }
  let(:application)     { Spec::ExampleApplication.new }

  example_class 'Spec::ExampleApplication', Ephesus::Core::Application \
  do |klass|
    klass.send :include, Ephesus::Bronze::Applications::Repository
  end

  example_class 'Spec::ExampleSession', Ephesus::Core::Session do |klass|
    # rubocop:disable RSpec/DescribedClass
    klass.send :include, Ephesus::Bronze::Sessions::Repository
    # rubocop:enable RSpec/DescribedClass
  end

  describe '#controller' do
    example_class 'Spec::ExampleController', Ephesus::Core::Controller

    before(:example) do
      described_class.controller('Spec::ExampleController')
    end

    it 'should pass the repository to the controller options' do
      expect(instance.controller.options[:repository])
        .to be application.repository
    end

    context 'when the controller defines a command' do
      example_class 'Spec::ExampleCommand', Ephesus::Core::Command do |klass|
        klass.send :include, Ephesus::Bronze::Commands::Repository
      end

      before(:example) do
        Spec::ExampleController.command :do_something, Spec::ExampleCommand
      end

      it 'should pass the repository to the command' do
        expect(instance.controller.do_something.repository)
          .to be application.repository
      end
    end
  end

  describe '#repository' do
    include_examples 'should have reader',
      :repository,
      -> { application.repository }
  end
end
