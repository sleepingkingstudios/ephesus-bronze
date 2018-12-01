# frozen_string_literal: true

require 'bronze/entities/entity'

require 'ephesus/bronze/entities/immutable'

RSpec.describe Ephesus::Bronze::Entities::Immutable do
  subject(:instance) { described_class.new(attributes) }

  let(:described_class) { Spec::ExampleEntity }
  let(:attributes)      { {} }

  example_class 'Spec::ExampleEntity', Bronze::Entities::Entity do |klass|
    # rubocop:disable RSpec/DescribedClass
    klass.send :include, Ephesus::Bronze::Entities::Immutable
    # rubocop:enable RSpec/DescribedClass
  end

  describe '#to_immutable' do
    shared_context 'when the entity class defines attributes' do
      before(:example) do
        Spec::ExampleEntity.attribute :color,   String
        Spec::ExampleEntity.attribute :pattern, String
        Spec::ExampleEntity.attribute :size,    Integer
      end
    end

    shared_context 'when the entity class defines associations' do
      example_class 'Spec::ParentEntity', Bronze::Entities::Entity do |klass|
        # rubocop:disable RSpec/DescribedClass
        klass.send :include, Ephesus::Bronze::Entities::Immutable
        # rubocop:enable RSpec/DescribedClass

        klass.attribute :name, String
      end

      example_class 'Spec::OneChildEntity', Bronze::Entities::Entity do |klass|
        # rubocop:disable RSpec/DescribedClass
        klass.send :include, Ephesus::Bronze::Entities::Immutable
        # rubocop:enable RSpec/DescribedClass

        klass.attribute :metal, String

        klass.references_one :object,
          class_name: 'Spec::ExampleEntity',
          inverse:    :material
      end

      example_class 'Spec::ManyChildrenEntity', Bronze::Entities::Entity \
      do |klass|
        # rubocop:disable RSpec/DescribedClass
        klass.send :include, Ephesus::Bronze::Entities::Immutable
        # rubocop:enable RSpec/DescribedClass

        klass.attribute :type, String

        klass.references_one :object,
          class_name: 'Spec::ExampleEntity',
          inverse:    :variants
      end

      before(:example) do
        Spec::ExampleEntity.references_one :parent,
          class_name: 'Spec::ParentEntity'

        Spec::ExampleEntity.has_one :material,
          class_name: 'Spec::OneChildEntity',
          inverse:    :object

        Spec::ExampleEntity.has_many :variants,
          class_name: 'Spec::ManyChildrenEntity',
          inverse:    :object
      end
    end

    shared_context 'when the entity class has a parent' do
      let(:parent) do
        Spec::ParentEntity.new(name: 'parent')
      end

      before(:example) do
        instance.parent = parent
      end
    end

    shared_context 'when the entity class has a material' do
      let(:material) do
        Spec::OneChildEntity.new(metal: 'bronze')
      end

      before(:example) do
        instance.material = material
      end
    end

    shared_context 'when the entity class has many variants' do
      let(:variants) do
        [
          Spec::ManyChildrenEntity.new(type: 'dieselpunk'),
          Spec::ManyChildrenEntity.new(type: 'radiumpunk'),
          Spec::ManyChildrenEntity.new(type: 'steampunk')
        ]
      end

      before(:example) do
        instance.variants = variants
      end
    end

    let(:expected) { { id: instance.id } }

    it 'should define the method' do
      expect(instance)
        .to respond_to(:to_immutable)
        .with(0).arguments
        .and_keywords(:include)
    end

    it { expect(instance.to_immutable).to be_a Hamster::Hash }

    it { expect(instance.to_immutable).to be == expected }

    wrap_context 'when the entity class defines attributes' do
      let(:expected) do
        super().merge(
          color:   nil,
          pattern: nil,
          size:    nil
        )
      end

      it { expect(instance.to_immutable).to be == expected }

      context 'when the attributes have values' do
        let(:attributes) do
          super().merge(
            color:   'chartreuse',
            pattern: 'plaid',
            size:    40
          )
        end
        let(:expected) { super().merge(attributes) }

        it { expect(instance.to_immutable).to be == expected }
      end
    end

    wrap_context 'when the entity class defines associations' do
      let(:expected) { super().merge(parent_id: nil) }

      it { expect(instance.to_immutable).to be == expected }

      describe 'with include: parent' do
        let(:expected) { super().merge(parent: nil) }

        it { expect(instance.to_immutable include: :parent).to be == expected }

        wrap_context 'when the entity class has a parent' do
          let(:expected) do
            super().merge(
              parent_id: parent.id,
              parent:    Hamster::Hash.new(
                id:   parent.id,
                name: parent.name
              )
            )
          end

          it 'should return an immutable hash including the parent' do
            expect(instance.to_immutable include: :parent).to be == expected
          end
        end
      end

      describe 'with include: [material]' do
        let(:expected) { super().merge(material: nil) }

        it 'should return an immutable hash' do
          expect(instance.to_immutable include: %i[material]).to be == expected
        end

        wrap_context 'when the entity class has a material' do
          let(:expected) do
            super().merge(
              material: Hamster::Hash.new(
                id:        material.id,
                object_id: instance.id,
                metal:     material.metal
              )
            )
          end

          it 'should return an immutable hash including the material' do
            expect(instance.to_immutable include: %i[material])
              .to be == expected
          end
        end
      end

      describe 'with include: [parent, material, variants]' do
        let(:expected) do
          super().merge(
            material: nil,
            parent:   nil,
            variants: Hamster::Vector.new
          )
        end

        it 'should return an immutable hash' do
          expect(instance.to_immutable include: %w[parent material variants])
            .to be == expected
        end

        wrap_context 'when the entity class has a parent' do
          let(:expected) do
            super().merge(
              parent_id: parent.id,
              parent:    Hamster::Hash.new(
                id:   parent.id,
                name: parent.name
              )
            )
          end

          it 'should return an immutable hash including the parent' do
            expect(instance.to_immutable include: %w[parent material variants])
              .to be == expected
          end
        end

        wrap_context 'when the entity class has a material' do
          let(:expected) do
            super().merge(
              material: Hamster::Hash.new(
                id:        material.id,
                object_id: instance.id,
                metal:     material.metal
              )
            )
          end

          it 'should return an immutable hash including the material' do
            expect(instance.to_immutable include: %w[parent material variants])
              .to be == expected
          end
        end

        wrap_context 'when the entity class has many variants' do
          let(:expected) do
            super().merge(
              variants: Hamster::Vector.new(
                [
                  Hamster::Hash.new(
                    id:        variants[0].id,
                    object_id: instance.id,
                    type:      variants[0].type
                  ),
                  Hamster::Hash.new(
                    id:        variants[1].id,
                    object_id: instance.id,
                    type:      variants[1].type
                  ),
                  Hamster::Hash.new(
                    id:        variants[2].id,
                    object_id: instance.id,
                    type:      variants[2].type
                  )
                ]
              )
            )
          end

          it 'should return an immutable hash including the variants' do
            expect(instance.to_immutable include: %w[parent material variants])
              .to be == expected
          end
        end
      end
    end

    context 'when the entity class defines many attributes and associations' do
      include_context 'when the entity class defines attributes'
      include_context 'when the entity class defines associations'

      let(:expected) do
        super().merge(
          color:     nil,
          parent_id: nil,
          pattern:   nil,
          size:      nil
        )
      end

      it { expect(instance.to_immutable).to be == expected }

      # rubocop:disable RSpec/NestedGroups
      describe 'with include: [parent, material, variants]' do
        let(:expected) do
          super().merge(
            material: nil,
            parent:   nil,
            variants: Hamster::Vector.new
          )
        end

        it 'should return an immutable hash' do
          expect(instance.to_immutable include: %w[parent material variants])
            .to be == expected
        end
      end
      # rubocop:enable RSpec/NestedGroups

      # rubocop:disable RSpec/NestedGroups
      context 'when the attributes and associations have values' do
        include_context 'when the entity class has a parent'
        include_context 'when the entity class has a material'
        include_context 'when the entity class has many variants'

        let(:attributes) do
          super().merge(
            color:   'chartreuse',
            pattern: 'plaid',
            size:    40
          )
        end
        let(:expected) do
          super()
            .merge(attributes)
            .merge(
              material:  Hamster::Hash.new(
                id:        material.id,
                object_id: instance.id,
                metal:     material.metal
              ),
              parent:    Hamster::Hash.new(
                id:   parent.id,
                name: parent.name
              ),
              parent_id: parent.id,
              variants:  Hamster::Vector.new(
                [
                  Hamster::Hash.new(
                    id:        variants[0].id,
                    object_id: instance.id,
                    type:      variants[0].type
                  ),
                  Hamster::Hash.new(
                    id:        variants[1].id,
                    object_id: instance.id,
                    type:      variants[1].type
                  ),
                  Hamster::Hash.new(
                    id:        variants[2].id,
                    object_id: instance.id,
                    type:      variants[2].type
                  )
                ]
              )
            )
        end

        it 'should return an immutable hash with the associations' do
          expect(instance.to_immutable include: %w[parent material variants])
            .to be == expected
        end
      end
      # rubocop:enable RSpec/NestedGroups
    end
  end
end
