class DonhangsController < ApplicationController
  def list
    @donhangs = Donhang.joins(:user, :chitietdonhang)
                       .select('donhang.*, users.username, users.sdt, users.email, users.diachi, chitietdonhang.sdt_nn, chitietdonhang.diachi_nn')
                       .order('donhang.id DESC')
  end

  def show
    @donhang = Donhang.find(params[:id])
  end

  def index
    @donhangs = Donhang.joins(:product, :chitietdonhang)
                       .select('donhang.*, products.name, chitietdonhang.soluong, chitietdonhang.dongia')
                       .order('donhang.id DESC')
  
    # Thêm dòng này để kiểm tra dữ liệu
    Rails.logger.debug "Donhangs: #{@donhangs.map { |d| [d.id, d.trangthaidonhang] }}"
  end

  def update_status
    @donhang = Donhang.find(params[:id])
    if @donhang.update(trangthaidonhang: params[:status])
      redirect_to @donhang, notice: 'Cập nhật trạng thái thành công'
    else
      redirect_to @donhang, alert: 'Không thể cập nhật trạng thái'
    end
  end

  def huy_don_hang
    @donhang = Donhang.find(params[:id])
    if @donhang.trangthaidonhang == 'Chưa xác nhận'
      if @donhang.update(trangthaidonhang: 'Đã hủy')
        flash[:success] = "Đã hủy đơn hàng thành công"
      else
        flash[:error] = "Không thể hủy đơn hàng"
      end
    else
      flash[:error] = "Không thể hủy đơn hàng ở trạng thái này"
    end
    redirect_to theo_doi_don_hang_path
  end

end 