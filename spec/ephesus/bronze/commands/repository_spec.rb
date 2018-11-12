# frozen_string_literal: true

require 'ephesus/bronze/commands/repository'
require 'ephesus/core/command'
require 'ephesus/core/utils/dispatch_proxy'

RSpec.describe Ephesus::Bronze::Commands::Repository do
  subject(:instance) do
    described_class.new(
      state,
      dispatcher: dispatcher,
      repository: repository
    )
  end

  let(:described_class) { Spec::ExampleCommand }
  let(:dispatcher) do
    instance_double(Ephesus::Core::Utils::DispatchProxy, dispatch: true)
  end
  let(:repository) { Object.new }
  let(:state)      { {} }

  example_class 'Spec::ExampleCommand', Ephesus::Core::Command do |klass|
    # rubocop:disable RSpec/DescribedClass
    klass.send :include, Ephesus::Bronze::Commands::Repository
    # rubocop:enable RSpec/DescribedClass
  end

  describe '::new' do
    it 'should define the constructor' do
      expect(described_class)
        .to be_constructible
        .with(1).argument
        .and_keywords(:dispatcher, :repository)
        .and_any_keywords
    end
  end

  describe '#repository' do
    include_examples 'should have reader', :repository, -> { repository }
  end
end
