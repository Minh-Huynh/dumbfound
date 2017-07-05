class ChangeRequestsThisMonthDefault < ActiveRecord::Migration[5.1]
  def change
    change_column_default :users, :requests_this_month, 0
    User.all.each{|u| u.update(requests_this_month: 0)}
  end
end
