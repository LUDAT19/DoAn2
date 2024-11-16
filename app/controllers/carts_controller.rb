class CartsController < ApplicationController
  def show
    @cart_items = session[:cart] || []
    if current_user
      @user = User.find_by(email: current_user.email)
    end
  end

  def add
    begin
      product = Product.find(params[:id])
      cart = session[:cart] || []

      item = cart.find { |i| i["id"].to_s == product.id.to_s }

      if item
        item["quantity"] = item["quantity"].to_i + 1
      else
        cart << {
          "id" => product.id,
          "name" => product.name,
          "price" => product.price,
          "quantity" => 1,
          "image_path" => product.image_path
        }
      end

      session[:cart] = cart
      cart_count = cart.sum { |item| item["quantity"].to_i }

      # Thêm header để tránh cache
      response.headers["Cache-Control"] = "no-cache, no-store"
      response.headers["Pragma"] = "no-cache"
      response.headers["Expires"] = "0"

      render json: {
        success: true,
        cart_count: cart_count,
        message: "Đã thêm vào giỏ hàng!",
        item: {
          id: product.id,
          name: product.name,
          price: product.price,
          quantity: item ? item["quantity"] : 1,
          image_path: product.image_path
        }
      }
    rescue ActiveRecord::RecordNotFound
      render json: {
        success: false,
        message: "Không tìm thấy sản phẩm"
      }, status: :not_found
    rescue => e
      render json: {
        success: false,
        message: "Có lỗi xảy ra: #{e.message}"
      }, status: :internal_server_error
    end
  end

  def remove
    cart = session[:cart] || []
    cart.delete_if { |item| item["id"].to_s == params[:id].to_s }
    session[:cart] = cart

    cart_count = cart.sum { |item| item["quantity"].to_i }

    render json: {
      success: true,
      cart_count: cart_count,
      message: "Đã xóa sản phẩm khỏi giỏ hàng"
    }
  end

  def clear
    session[:cart] = []
    respond_to do |format|
      format.json { render json: { success: true } }
    end
  end

  def update
    product_id = params[:id]
    new_quantity = params[:quantity].to_i

    if new_quantity < 1
      render json: {
        success: false,
        message: "Số lượng phải lớn hơn 0"
      }
      return
    end

    cart = session[:cart] || []
    item = cart.find { |i| i["id"].to_s == product_id.to_s }

    if item
      item["quantity"] = new_quantity
      session[:cart] = cart
      cart_count = cart.sum { |item| item["quantity"].to_i }

      render json: {
        success: true,
        cart_count: cart_count,
        message: "Đã cập nhật số lượng"
      }
    else
      render json: {
        success: false,
        message: "Không tìm thấy sản phẩm trong giỏ hàng"
      }
    end
  end

  def count
    cart = session[:cart] || []
    count = cart.sum { |item| item["quantity"].to_i }
    render json: { count: count }
  end

  private

  def cart_params
    params.permit(:id, :name, :price, :image_path, :quantity)
  end
end
