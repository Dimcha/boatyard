require 'spec_helper'

describe Route do
  describe 'route creation' do
    let(:route) { Route.new('A', 'B', 5) }

    it { expect(route.from).to eq('A') }
    it { expect(route.to).to eq('B') }
    it { expect(route.distance).to eq(5) }
    it { expect(route.visited).to eq(false) }
  end

  describe 'connected routes creation' do
    let!(:routes) { Routes.new('AB5, BC4, CA1') }
    let!(:routes1) { Routes.new('AB5, BC4, CA1, BD3') }
    let(:route) { Route.new('A', 'B', 5) }

    it { expect(route.connected_routes(routes.all_routes).size).to eq(1) }
    it { expect(route.connected_routes(routes1.all_routes).size).to eq(2) }
  end
end
