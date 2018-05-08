require 'spec_helper'

RSpec.describe ActsAsGraph do

  class Task
    include ActsAsGraph
  end

  it 'should work' do
    expect(1).to eq(1)
  end

end
