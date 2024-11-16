class CheckoutController < ApplicationController
  before_action :check_user_login

  def show
    @user = current_user

    if params[:product_id].blank?
      flash[:error] = "Vui lòng chọn sản phẩm"
      redirect_to root_path
      return
    end

    if params[:quantity].blank? || params[:quantity].to_i < 1
      flash[:error] = "Số lượng không hợp lệ"
      redirect_to root_path
      return
    end

    begin
      @product = Product.find(params[:product_id])
      @quantity = params[:quantity].to_i
      @total = @product.price * @quantity
    rescue ActiveRecord::RecordNotFound
      flash[:error] = "Không tìm thấy sản phẩm"
      redirect_to root_path
    end
  end

  def create
    begin
      ActiveRecord::Base.transaction do
        # Tạo đơn hàng mới
        @donhang = Donhang.new(
          tongtien: params[:tongtien],
          thoigiantao: Time.current,
          thoigiancapnhat: Time.current,
          phuongthucthanhtoan: params[:payment_method],
          tennganhang: params[:payment_method] == "thanh_toan_the" ? params[:tennganhang] : nil,
          sothe: params[:payment_method] == "thanh_toan_the" ? params[:card_number] : nil,
          tenchuthe: params[:payment_method] == "thanh_toan_the" ? params[:card_name] : nil,
          id_kh: current_user.id,
          id_sp: params[:id_sp],
          trangthaidonhang: "Chờ xác nhận"
        )

        unless @donhang.save
          error_messages = @donhang.errors.full_messages.join(", ")
          flash[:error] = "Lỗi khi tạo đơn hàng: #{error_messages}"
          raise ActiveRecord::Rollback
        end

        # Lấy thông tin sản phẩm
        product = Product.find(params[:id_sp])
        
        # Tạo đường dẫn ảnh đầy đủ
        full_image_path = "#{request.base_url}/assets/#{product.image_path}"

        # Tạo chi tiết đơn hàng với đường dẫn ảnh đầy đủ
        @chitietdonhang = Chitietdonhang.new(
          donhang_id: @donhang.id,
          tensanpham: product.name,
          anhsanpham: full_image_path,  # Sử dụng đường dẫn ảnh đầy đủ
          soluong: params[:quantity],
          dongia: product.price,
          thanhtien: params[:tongtien],
          thoigiantao: Time.current,
          thoigiancapnhat: Time.current,
          sdt_nn: params[:receiver_phone],
          diachi_nn: params[:receiver_address]
        )

        unless @chitietdonhang.save
          error_messages = @chitietdonhang.errors.full_messages.join(", ")
          flash[:error] = "Lỗi khi tạo chi tiết đơn hàng: #{error_messages}"
          raise ActiveRecord::Rollback
        end

        # Lưu ID đơn hàng vào session để hiển thị trang success
        session[:last_order_id] = @donhang.id

        flash[:success] = "Đặt hàng thành công!"
        redirect_to checkout_success_path and return
      end
    rescue => e
      flash[:error] = "Đã xảy ra lỗi: #{e.message}"
    end

    redirect_to checkout_path(product_id: params[:id_sp], quantity: params[:quantity])
  end

  def success
    # Có thể thêm logic để hiển thị thông tin đơn hàng vừa đặt
    @donhang = Donhang.find_by(id: session[:last_order_id])
  end

  private

  def donhang_params
    params.permit(
      :id_sp,
      :tongtien,
      :quantity,
      :price,
      :payment_method,
      :tenganhang,  # Thêm tenganhang vào permitted params
      :card_number,
      :card_name,
      :receiver_phone,
      :receiver_address
    )
  end

  def chitietdonhang_params
    params.require(:chitietdonhang).permit(
      :receiver_phone, :receiver_address,
      :payment_method, :bank_name, :card_number, :card_name
    )
  end

  def require_login
    unless logged_in?
      redirect_to dangnhap_path, alert: "Vui lòng đăng nhập để tiếp tục"
    end
  end
end
