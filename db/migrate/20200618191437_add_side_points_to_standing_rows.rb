class AddSidePointsToStandingRows < ActiveRecord::Migration[5.2]
  def change
    add_column :standing_rows, :corp_points, :integer
    add_column :standing_rows, :runner_points, :integer
  end
end
