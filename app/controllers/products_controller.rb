class ProductsController < ApplicationController
  before_action :authenticate_user!, only: [ :add_to_cart, :buy_now ]

  def index
    @products = Product.all

    respond_to do |format|
      format.html { render layout: request.xhr? ? false : "application" }
    end
  end

  def new
    @product = Product.new
    @danhmuc_options = Danhmucsanpham.all
    @image_files = Dir.glob("app/assets/images/*").map { |path| File.basename(path) }
  end

  def create
    next_id = Product.maximum(:id).to_i + 1
    @product = Product.new(product_params)
    @product.id = next_id

    if params[:product][:image_path].blank?
      @product.image_path = nil
    end

    if @product.save
      redirect_to products_path, notice: "Sản phẩm đã được tạo thành công."
    else
      @danhmuc_options = Danhmucsanpham.all
      @image_files = Dir.glob("app/assets/images/*").map { |path| File.basename(path) }
      render :new
    end
  end

  def edit
    @product = Product.find(params[:id])
    @danhmuc_options = Danhmucsanpham.all
    @image_files = Dir.glob("app/assets/images/*").map { |path| File.basename(path) }
  end

  def update
    @product = Product.find(params[:id])
    if @product.update(product_params)
      redirect_to products_path, notice: "Sản phẩm đã được cập nhật thành công."
    else
      @danhmuc_options = Danhmucsanpham.all
      @image_files = Dir.glob("app/assets/images/*").map { |path| File.basename(path) }
      render :edit
    end
  end

  def destroy
    @product = Product.find(params[:id])
    @product.destroy
    redirect_to products_path, notice: "Sản phẩm đã được xóa thành công."
  end

  def show
    @product = Product.find(params[:id])
  end

  def add_to_cart
    @product = Product.find(params[:id])
    # Thêm logic xử lý thêm vào giỏ hàng ở đây
    redirect_to @product, notice: "Đã thêm sản phẩm vào giỏ hàng"
  end

  def buy_now
    @product = Product.find(params[:id])
    # Thêm logic xử lý mua ngay ở đây
    redirect_to checkout_path, notice: "Tiến hành thanh toán"
  end

  def search
    query = params[:query].to_s.downcase

    # Tìm sản phẩm theo tên
    @product = Product.find_by("LOWER(name) LIKE ?", "%#{query}%")

    if @product
      # Nếu tìm thấy sản phẩm, chuyển hướng đến danh mục của sản phẩm đó
      redirect_to show_category_products_path(id: @product.id_dm)
    else
      # Nếu không tìm thấy, hiển thị thông báo
      flash[:notice] = "Không tìm thấy sản phẩm '#{params[:query]}'"
      redirect_back(fallback_location: root_path)
    end
  end



  private

  def product_params
    params.require(:product).permit(:name, :id_dm, :mota, :price, :image_path, :soluong)
  end
end
