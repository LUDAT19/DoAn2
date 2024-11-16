class HomeController < ApplicationController
  # Cho phép truy cập vào trang index và index2 mà không cần đăng nhập
  before_action :require_login, except: [ :index ]

  def index
    @products = Product.all
  end

  def index2
    @products = Product.all
  end

  def index3
    # Đếm tổng số sản phẩm trực tiếp từ bảng products
    @total_products = Product.count

    # Đếm số đơn hàng được đặt trong ngày hôm nay
    @new_orders = Donhang.where('DATE(thoigiantao) = ?', Date.today).count

    # Tính tổng doanh thu từ các đơn hàng đã thanh toán
    @total_revenue = Donhang.where(trangthaidonhang: 'Đã thanh toán').sum(:tongtien)
  rescue => e
    
  end

  def show_category_products
    @category = Danhmucsanpham.find(params[:id])
    @products = Product.where(id_dm: @category.id)
  end

  def thongke
    # Thống kê tổng quan
    @total_orders = Donhang.count
    @total_revenue = Donhang.where(trangthaidonhang: 'Đã thanh toán').sum(:tongtien)
    @total_users = User.count
    @total_products = Product.count

    # Top 5 sản phẩm bán chạy (chỉ từ đơn hàng đã thanh toán)
    @top_products = Product.joins('INNER JOIN donhang ON donhang.id_sp = products.id')
                          .joins('INNER JOIN chitietdonhang ON chitietdonhang.donhang_id = donhang.id')
                          .where(donhang: { trangthaidonhang: 'Đã thanh toán' })
                          .select('products.*, 
                                  SUM(chitietdonhang.soluong) as total_sold, 
                                  SUM(chitietdonhang.soluong * products.price) as revenue')
                          .group('products.id')
                          .order('total_sold DESC')
                          .limit(5)

    # Doanh thu 7 ngày gần nhất (chỉ từ đơn hàng đã thanh toán)
    @daily_revenue = Donhang.where('thoigiantao >= ?', 7.days.ago)
                           .group('DATE(thoigiantao)')
                           .sum('tongtien')

    # Thống kê theo danh mục
    @category_stats = Danhmucsanpham.joins('INNER JOIN products ON products.id_dm = danhmucsanphams.id')
                                   .select('danhmucsanphams.*, 
                                          danhmucsanphams.ten_danhmuc,
                                          COUNT(products.id) as product_count')
                                   .group('danhmucsanphams.id, danhmucsanphams.ten_danhmuc')

    # Đơn hàng gần đây
    @recent_orders = Donhang.order('thoigiantao DESC')
                           .limit(10)

    # Thống kê số lượng đơn hàng theo ngày
    @daily_orders = Donhang.where('thoigiantao >= ?', 7.days.ago)
                           .group('DATE(thoigiantao)')
                           .count

    # Thống kê phương thức thanh toán
    @payment_methods = Donhang.group(:phuongthucthanhtoan)
                             .count

    # Thêm dữ liệu cho biểu đồ phân bố danh mục
    @category_distribution = Danhmucsanpham.joins(:products)
                                         .group('danhmucsanphams.ten_danhmuc')
                                         .count
  end

  private

  def require_login
    unless logged_in?
      flash[:danger] = "Bạn cần đăng nhập để xem trang này."
      redirect_to dangnhap_path
    end
  end

  def logged_in?
    !session[:user_id].nil?
  end
end
