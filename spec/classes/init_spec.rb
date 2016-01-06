require 'spec_helper'
describe 'kubernetes' do

  context 'with defaults for all parameters' do
    it { should_not compile }
  end
end
