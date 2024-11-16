class OrdersController < ApplicationController
  def create
    begin
      ActiveRecord::Base.transaction do
        # Tạo đơn hàng mới
        @donhang = Donhang.new(
          tongtien: calculate_total_price(params[:chitietdonhang]),
          trangthaidonhang: "Chưa xác nhận",
          phuongthucthanhtoan: params[:donhang][:phuongthucthanhtoan],
          id_kh: current_user.id,
          id_sp: params[:chitietdonhang].first[:product_id],
          thoigiantao: Time.current,
          thoigiancapnhat: Time.current
        )

        if params[:donhang][:phuongthucthanhtoan] == "thanh_toan_the"
          @donhang.sothe = params[:donhang][:sothe]
          @donhang.tenchuthe = params[:donhang][:tenchuthe]
          @donhang.tennganhang = params[:donhang][:tennganhang]
        end

        if @donhang.save
          # Debug log
          Rails.logger.info "Processing order items with images..."

          params[:chitietdonhang].each do |chitiet|
            # Debug log
            Rails.logger.info "Item image path: #{chitiet[:anhsanpham]}"

            Chitietdonhang.create!(
              donhang_id: @donhang.id,
              tensanpham: chitiet[:tensanpham],
              anhsanpham: chitiet[:anhsanpham].presence,
              soluong: chitiet[:soluong],
              dongia: chitiet[:dongia],
              thanhtien: chitiet[:soluong].to_i * chitiet[:dongia].to_i,
              sdt_nn: params[:donhang][:sdt_nn],
              diachi_nn: params[:donhang][:diachi_nn],
              thoigiantao: Time.current,
              thoigiancapnhat: Time.current
            )
          end

          # Chỉ xóa những sản phẩm đã được chọn khỏi giỏ hàng
          selected_product_ids = params[:chitietdonhang].map { |item| item[:product_id] }
          session[:cart] = session[:cart].reject { |item| selected_product_ids.include?(item["id"].to_s) }

          # Chuyển hướng đến trang thành công
          redirect_to order_success_path(order_id: @donhang.id)
        else
          render json: { success: false, message: @donhang.errors.full_messages.join(", ") }
        end
      end
    rescue => e
      Rails.logger.error "Lỗi khi tạo đơn hàng: #{e.message}"
      Rails.logger.error "Params: #{params.inspect}"
      render json: { success: false, message: "Có lỗi xảy ra khi xử lý đơn hàng: #{e.message}" }
    end
  end

  def success
    @donhang = Donhang.find_by(id: params[:order_id])
    if @donhang
      render "orders/success"
    else
      redirect_to root_path, alert: "Không tìm thấy đơn hàng"
    end
  end

  def list
    @orders = Donhang.joins(:user)
                     .select('donhangs.*, users.username, users.sdt, users.email, users.diachi')
                     .order(created_at: :desc)
  end
  private

  def calculate_total_price(order_details)
    order_details.sum { |detail| detail[:dongia].to_i * detail[:soluong].to_i }
  end
end
