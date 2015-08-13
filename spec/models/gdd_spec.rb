require 'rails_helper'

describe GDD::Accumulator do
  let(:collection) do
    {
      5.days.ago.to_date => 10,
      4.days.ago.to_date => 15,
      3.days.ago.to_date => 10,
      2.days.ago.to_date => 15,
      1.day.ago.to_date => 10,
    }
  end

  it 'accumulates growing degrees per day' do
    output = GDD::Accumulator.(gdd_collection_by_date: collection)

    expected = {
      5.days.ago.to_date => 10,
      4.days.ago.to_date => 25,
      3.days.ago.to_date => 35,
      2.days.ago.to_date => 50,
      1.day.ago.to_date => 60,
    }

    expect(output).to eq(expected)
  end
end

describe GDD::Notifier do
  let(:collection) do
    {
      2.days.ago.to_date => 10,
      1.day.ago.to_date => 15,
      Date.current => 10,
      1.day.from_now.to_date => 5,
      2.days.from_now.to_date => 10
    }
  end

  it 'sends notification when gdd target is within two day of the future' do
    allow(GDD::Notifier).to receive(:notify)

    accumulated_gdd_data = GDD::Accumulator.(gdd_collection_by_date: collection)

    GDD::Notifier.(gdd_data: accumulated_gdd_data, gdd_target: 50)

    expect(GDD::Notifier).to have_received(:notify)
  end
end
