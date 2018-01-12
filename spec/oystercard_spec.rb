require "oystercard"

describe Oystercard do

  let(:entry_station) { double :station }
  let(:exit_station) { double :station }
  let(:journeylog) { double :JourneyLog }
  let(:penalty) {5}
  subject(:oystercard) {described_class.new(journeylog)}

  describe "#initialize" do
    it 'sets zero balance on new oystercard' do
      expect(oystercard.balance).to eq 0
    end
  end

  describe '#top_up' do
    it 'can top up the balance' do
      expect{ oystercard.top_up 1 }.to change{ oystercard.balance }.by 1
    end

    it 'raises error when balance excedes balance limit' do
      oystercard = described_class.new(journeylog, Oystercard::BALANCE_LIMIT)
      message = "Balance limit of #{Oystercard::BALANCE_LIMIT} reached"
      expect{ oystercard.top_up(1) }.to raise_error message
    end
  end

  describe '#touch_in' do


    it 'raises error when touched in card has insufficient balance'do
      expect{oystercard.touch_in(entry_station)}.to raise_error 'Insufficient balance'
    end

    it 'charges penalty fare if you touch in twice in a row' do
      oystercard = described_class.new(journeylog, Oystercard::BALANCE_LIMIT)
      oystercard.touch_in(entry_station)
      allow(journeylog).to receive(:started?).and_return(true)
      expect{oystercard.touch_in(entry_station)}.to change{ oystercard.balance }.by -5
    end

  end

  describe '#touch_out'do
    before do
      oystercard = described_class.new(journeylog, Oystercard::BALANCE_LIMIT)
      allow(journeylog).to receive(:new)
      allow(journeylog).to receive(:end).with(exit_station)
      allow(journeylog).to receive(:fare).and_return(penalty)
    end

    it "charges fare when you touched out" do
      expect{oystercard.touch_out(exit_station)}.to change{oystercard.balance}.by(-5)
    end

    it 'stores a journey'do
    oystercard.touch_out(exit_station)
    expect(oystercard.journeys).to include journey
    end

  end

  end
