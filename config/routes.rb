Rails.application.routes.draw do
  root "home#index"

  get "index2", to: "home#index2"
  get "index3", to: "home#index3", as: "index3"
  get "dangnhap", to: "sessions#new", as: "dangnhap"
  post "dangnhap", to: "sessions#create"
  get "dangky", to: "dangky#index", as: "dangky"
  post "dangky", to: "dangky#create"
  get "/logout", to: "sessions#log_out", as: "get_logout"
  delete "logout", to: "sessions#destroy", as: "logout"

  # Forget password routes
  get "password_resets/new", to: "password_resets#new", as: "new_password_reset"
  post "password_resets", to: "password_resets#create", as: "password_resets"
  get "password_resets/edit", to: "password_resets#edit", as: "edit_password_reset"
  patch "password_resets/update", to: "password_resets#update", as: "update_password_reset"

  get "login", to: "sessions#new", as: "login"
  get "gioi_thieu", to: "introduce#show", as: :gioi_thieu # Đường dẫn cho trang giới thiệu
  # Uncomment below if needed
  # if Rails.env.development?
  #   mount LetterOpenerWeb::Engine, at: "/letter_opener"
  # end

  # Các tuyến đờng khác nếu cần...
  # get "home/index"
  # get "up" => "rails/health#show", as: :rails_health_check
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # root "posts#index"

  get "danhmuc/:id/products", to: "home#show_category_products", as: "show_category_products"

  resources :products do
    member do
      post "add_to_cart"
      post "buy_now"
    end
  end
  resources :users do
    member do
      patch :update, defaults: { format: :json }
    end
  end
  resources :accounts
  resources :danhmucsanphams do
    member do
      get :transfer_products
      patch :update_products
    end
  end

  delete "/dangxuat", to: "sessions#destroy", as: "dangxuat"

  get "/profile", to: "users#profile", as: "user_profile"
  get "/profile/edit", to: "users#edit_profile", as: "edit_profile"
  patch "/profile/update", to: "users#update_profile", as: "update_profile"

  # Thêm routes cho giỏ hàng
  get "/cart", to: "carts#show", as: "cart"
  post "/cart/add/:id", to: "carts#add", as: "add_to_cart"
  delete "/cart/remove/:id", to: "carts#remove", as: "remove_from_cart"
  patch "/cart/update/:id", to: "carts#update", as: "update_cart"
  delete "/cart/clear", to: "carts#clear", as: "clear_cart"
  delete "/cart/remove/:id", to: "carts#remove", as: "remove_cart_item"
  get "/cart/count", to: "carts#count"

  post "/orders/create", to: "orders#create"

  post "cart/clear", to: "carts#clear"

  get "/checkout", to: "checkout#show"
  post "/orders", to: "orders#create"
  get "/checkout", to: "checkout#show"
  post "/checkout/create", to: "checkout#create", as: "create_order"
  post "create_order", to: "checkout#create"
  # Thêm route cho order success
  get "/order_success", to: "orders#success", as: "order_success"

  # Thêm route này nếu chưa có

  # Hoặc nếu không cần id trong URL

  get "/checkout/success", to: "checkout#success", as: "checkout_success"

  post "checkout/create", to: "checkout#create", as: "checkout_create"

  get "orders/list", to: "orders#list", as: "orders_list"
  # Thay vì dùng resources :donhangs, chúng ta chỉ định nghĩa route cần thiết
  get "donhangs/list", to: "donhangs#list", as: "list_donhangs"
  resources :donhangs do
    collection do
      get "list"
    end
    member do
      patch "update_status"
    end
  end
  get "thongke", to: "home#thongke"
  get "theo_doi_don_hang", to: "donhangs#index"
  get "chi_tiet_don_hang/:id", to: "donhangs#show", as: "chi_tiet_don_hang"
  patch "huy_don_hang/:id", to: "donhangs#huy_don_hang", as: "huy_don_hang"

  post "/cart/add", to: "carts#add"

  # Thêm route cho giỏ hàng

  # hoặc có thể viết gọn hơn với resources

  get "/search", to: "products#search", as: "search_products"
end
