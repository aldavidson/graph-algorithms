require_relative '../app_helper'
require 'models/lifo_queue'

describe LiFoQueue do
  describe '#push!' do
    context 'given a single item' do
      let(:item){ 'my item' }

      it 'adds the item to the queue' do
        expect{ subject.push!(item) }.to change(subject, :last).from(nil).to(item)
      end
    end

    context 'given multiple items' do
      it 'adds each item to the queue' do
        expect{ subject.push!('item', 'other_item')}.to change(subject, :size).from(0).to(2)
      end
    end

    context 'given an array of items' do
      it 'adds each item to the queue' do
        expect{ subject.push!(['item', 'other_item']) }.to change(subject, :size).from(0).to(2)
      end
    end
  end

  describe "#pop!" do
    context "when the queue has items" do
      before do
        subject.push!('a', 'b', 'c')
      end

      context "given no args" do
        it "takes the last item off the queue" do
          expect{ subject.pop! }.to change(subject, :last).from('c').to('b')
        end
        it "returns the item" do
          expect(subject.pop!).to eq('c')
        end
      end

      context "given a number of items" do
        it "takes that many items off the end of the queue" do
          expect{ subject.pop!(2) }.to change(subject, :last).from('c').to('a')
        end
        it "returns the first n items" do
          expect(subject.pop!(2)).to eq(['c', 'b'])
        end
      end

      context "given a number of items bigger than the size of the queue" do
        it "returns the whole queue" do
          expect(subject.pop!(7)).to eq(['c', 'b', 'a'])
        end

        it "empties the queue" do
          expect{subject.pop!(7)}.to change(subject, :empty?).from(false).to(true)
        end
      end
    end
  end
end