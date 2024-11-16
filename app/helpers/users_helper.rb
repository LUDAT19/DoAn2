module UsersHelper
  def display_quyen(loai_quyen)
    case loai_quyen
    when 'admin'
      'Admin'
    when 'staff'
      'Nhân viên'
    when 'customer'
      'Khách hàng'
    else
      'Không xác định'
    end
  end
end 