class DanhmucsanphamsController < ApplicationController
  def index
    @danhmucs = Danhmucsanpham.all
  end

  def new
    @danhmuc = Danhmucsanpham.new
  end

  def create
    @danhmuc = Danhmucsanpham.new(danhmuc_params)
    if @danhmuc.save
      redirect_to danhmucsanphams_path, notice: 'Thêm danh mục thành công.'
    else
      render :new
    end
  end

  def edit
    @danhmuc = Danhmucsanpham.find(params[:id])
  end

  def update
    @danhmuc = Danhmucsanpham.find(params[:id])
    if @danhmuc.update(danhmuc_params)
      redirect_to danhmucsanphams_path, notice: 'Cập nhật danh mục thành công.'
    else
      render :edit
    end
  end

  def destroy
    @danhmuc = Danhmucsanpham.find(params[:id])
    if @danhmuc.products.exists?
      redirect_to danhmucsanphams_path, 
        alert: "Không thể xóa danh mục này vì đang có sản phẩm thuộc danh mục!"
    else
      @danhmuc.destroy
      redirect_to danhmucsanphams_path, notice: 'Xóa danh mục thành công.'
    end
  end

  private

  def danhmuc_params
    params.require(:danhmucsanpham).permit(:ten_danhmuc)
  end
end