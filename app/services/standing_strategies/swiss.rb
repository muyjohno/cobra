module StandingStrategies
  class Swiss < Base
    def calculate!
      SosCalculator.calculate!(stage)
    end
  end
end
