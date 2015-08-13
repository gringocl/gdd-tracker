module GDD
  class Accumulator
    def self.call(gdd_collection_by_date:)
      new(gdd_collection_by_date).run
    end

    def initialize(gdd_collection_by_date)
      @collection = gdd_collection_by_date
    end

    def run
      total = 0

      collection.map { |key, value| [key, total += value] }.to_h
    end

    private

    attr_reader :collection
  end

  class Notifier
    def self.call(gdd_data:, gdd_target:)
      new(data: gdd_data, target: gdd_target).run
    end

    def initialize(data:, target:)
      @data = data
      @target = target
    end

    def self.notify
    end

    private

    attr_reader :data, :target
  end
end

