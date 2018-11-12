# frozen_string_literal: true

require 'ephesus/core/application'
require 'ephesus/bronze/applications/repository'

RSpec.describe Ephesus::Bronze::Applications::Repository do
  subject(:instance) { described_class.new }

  let(:described_class) { Spec::ExampleApplication }

  example_class 'Spec::ExampleApplication', Ephesus::Core::Application \
  do |klass|
    # rubocop:disable RSpec/DescribedClass
    klass.send :include, Ephesus::Bronze::Applications::Repository
    # rubocop:enable RSpec/DescribedClass
  end

  describe '::new' do
    it 'should define the constructor' do
      expect(described_class)
        .to be_constructible
        .with(0).arguments
        .and_keywords(:repository, :state)
    end
  end

  describe '#repository' do
    shared_context 'when a custom repository is defined' do
      example_class 'Spec::CustomRepository' do |klass|
        klass.send :include, Bronze::Collections::Repository
      end

      before(:example) do
        Spec::ExampleApplication.define_method(:build_repository) do
          Spec::CustomRepository.new
        end
      end
    end

    include_examples 'should have reader',
      :repository,
      -> { be_a Bronze::Collections::Repository }

    wrap_context 'when a custom repository is defined' do
      it { expect(instance.repository).to be_a Spec::CustomRepository }
    end

    context 'when initialized with a repository' do
      let(:repository) { Spec::ExampleRepository.new }
      let(:instance)   { described_class.new(repository: repository) }

      example_class 'Spec::ExampleRepository' do |klass|
        klass.send :include, Bronze::Collections::Repository
      end

      it { expect(instance.repository).to be repository }

      wrap_context 'when a custom repository is defined' do
        it { expect(instance.repository).to be repository }
      end
    end
  end
end
