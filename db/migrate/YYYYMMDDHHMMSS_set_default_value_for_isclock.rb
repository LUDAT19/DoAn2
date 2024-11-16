class SetDefaultValueForIsclock < ActiveRecord::Migration[7.0]
  def change
    # Set giá trị mặc định là 1 cho cột isclock
    change_column_default :users, :isclock, 1
    
    # Cập nhật tất cả record hiện tại có isclock là nil hoặc 0 thành 1
    User.where(isclock: [nil, 0]).update_all(isclock: 1)
  end
end 