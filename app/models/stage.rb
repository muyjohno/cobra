class Stage < ApplicationRecord
  enum format: {
    swiss: 0,
    double_elim: 1
  }
end
