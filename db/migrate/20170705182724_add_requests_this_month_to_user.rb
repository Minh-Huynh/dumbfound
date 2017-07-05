class AddRequestsThisMonthToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :requests_this_month, :integer
  end
end
