module StandingStrategies
  class Swiss < Base
    def calculate!
      SosCalculator.calculate!(tournament)
    end
  end
end
