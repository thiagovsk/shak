require 'shak/cookbook_input'

describe Shak::CookbookInput do

  let(:input) do
    Shak::CookbookInput.new
  end

  it 'can have a text input' do
    input.instance_eval do
      text :text1
    end

    expect(input.fields.first.name).to eq(:text1)
  end

  it 'can have a select input' do
    input.instance_eval do
      select :select1
    end

    expect(input.fields.first.name).to eq(:select1)
  end

  it 'can have a blob input' do
    input.instance_eval do
      blob :blob1
    end
    expect(input.fields.first.name).to eq(:blob1)
  end

  it 'can have a boolean input' do
    input.instance_eval do
      boolean :boolean1
    end
    expect(input.fields.first.name).to eq(:boolean1)
  end

  it 'passes block down to new field' do
    input.select :foo do
      title 'Foo Bar'
    end
    expect(input.fields.first.title).to eq('Foo Bar')
  end

  context 'validating and testing good formation' do
    let(:field1) { Shak::CookbookInput::Field.new(:foo) }
    let(:field2) { Shak::CookbookInput::Field.new(:bar) }
    before(:each) do
      input.fields << field1 << field2
    end

    it 'is valid when all fields are valid' do
      expect(input).to be_valid
    end

    it 'is not valid if any field is not' do
      expect(field1).to receive(:valid?).and_return(false)
      expect(input).to_not be_valid
    end

    it 'checks semantics by chaking all fields' do
      expect(field1).to receive(:check_semantics!)
      expect(field2).to receive(:check_semantics!)
      input.check_semantics!
    end

    it 'collects errors from fields' do
      expect(field1).to receive(:errors).and_return(['one error'])
      expect(field2).to receive(:errors).and_return(['another error'])

      expect(input.errors).to eq(['one error', 'another error'])
    end
  end

  it 'defines unique keys' do
    input.instance_eval do
      text :foo
      text :bar
      unique :foo, :bar
    end

    expect(input.unique_keys).to eq([[:foo, :bar]])
  end

end

# TODO move all specs below to their own files

describe Shak::CookbookInput::Field do
  let(:field) { described_class.new(:the_field) }

  it 'is not mandatory by default' do
    expect(field).to_not be_mandatory
  end

  it 'can be set as mandatory' do
    field.mandatory
    expect(field).to be_mandatory
  end

  it 'assigns value' do
    field.value = 'foo'
    expect(field.value).to eq('foo')
  end

  context 'validation' do
    it 'is valid by default' do
      expect(field).to be_valid
    end
    it 'is not valid if mandatory and not filled' do
      field.mandatory
      expect(field).to_not be_valid
    end
    it 'is not valid if mandatory and filled with an empty string' do
      field.mandatory
      field.value = ''
      expect(field).to_not be_valid
    end
    it 'is valid if mandatory and filled' do
      field.mandatory
      field.value = 'foo'
      expect(field).to be_valid
    end

    it 'is valid if mandatory and dependent on the value of another field that is not selected' do
      field_set = Shak::CookbookInput.new
      field_set.select :other_field do
        option :foo, 'Foo'
        option :bar, 'Bar'
      end
      field_set[:other_field] = :bar

      field.field_set = field_set
      field.dependent_on :other_field, :foo
      field.mandatory

      expect(field).to be_ignored
    end
  end

  it 'has valid semantics by default' do
    field.check_semantics!
  end

  it 'has no valid semantics if depends on unexisting field' do
    field.field_set = Shak::CookbookInput.new
    field.dependent_on :foo, :bar
    expect(lambda { field.check_semantics! }).to raise_error(Shak::CookbookInput::Field::InvalidSemantics)
  end

  it 'can have a default value' do
    field.default 'foo'
    expect(field.value).to eq('foo')
  end

  it 'compares for equality' do
    field.value = 'text'
    other = field.dup

    expect(field).to eq(other)

    other.value = 'changed'
    expect(field).to_not eq(other)
  end

end

describe Shak::CookbookInput::TextField do
  # not much to add wrt a abstract field ...
end

describe Shak::CookbookInput::SelectField do
  let(:field) { described_class.new(:the_field) }

  it 'casts value to symbol' do
    field.value = 'foo'
    expect(field.value).to eq(:foo)
  end

  it 'has options' do
    field.option :foo, 'Foo'
    field.option :bar, 'Bar'

    expect(field.options.map(&:value)).to include(:foo, :bar)
  end

  context 'validating' do
    before(:each) do
      field.option :foo, 'Foo'
      field.option :bar, 'Bar'
    end

    it 'is invalid if filled with undeclared option' do
      field.value = :baz
      expect(field).to_not be_valid
    end

    it 'is valid if not mandatory and not filled' do
      expect(field).to be_valid
    end

    it 'is invalid if mandatory and not filled' do
      field.mandatory
      expect(field).to_not be_valid
    end
  end

  context 'testing good formation' do
    it 'is malformed it has no options' do
      expect(lambda { field.check_semantics! }).to raise_error(Shak::CookbookInput::Field::InvalidSemantics)
    end
    it 'is well formed if has options' do
      field.option :foo, 'Foo'
      field.check_semantics!
    end
  end

end

describe Shak::CookbookInput::SelectField::Option do
  let(:option) { described_class.new(:name) }
  # nothing worthy of testing yet
end
