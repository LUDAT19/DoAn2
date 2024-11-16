document.addEventListener('turbolinks:load', function() {
    // Khởi tạo biến global để theo dõi số lượng giỏ hàng
    window.cartCount = parseInt(document.getElementById('cart-count') ? .textContent || '0');

    // Hàm cập nhật số lượng giỏ hàng
    window.updateCartCount = function(count) {
        window.cartCount = count;
        const cartCountElement = document.getElementById('cart-count');
        if (cartCountElement) {
            cartCountElement.textContent = count;
            cartCountElement.classList.add('update-animation');
            setTimeout(() => {
                cartCountElement.classList.remove('update-animation');
            }, 300);
        }
    };

    // Thêm sự kiện cho nút "Thêm vào giỏ"
    document.querySelectorAll('.add-to-cart').forEach(button => {
        button.addEventListener('click', function(e) {
            e.preventDefault();

            const productId = this.dataset.productId;

            // Cập nhật UI ngay lập tức
            updateCartCount(window.cartCount + 1);

            fetch(`/cart/add/${productId}`, {
                    method: 'POST',
                    headers: {
                        'X-CSRF-Token': document.querySelector('[name="csrf-token"]').content,
                        'Content-Type': 'application/json',
                        'Accept': 'application/json'
                    },
                    credentials: 'same-origin'
                })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        // Cập nhật lại số chính xác từ server
                        updateCartCount(data.cart_count);
                        showNotification('Đã thêm vào giỏ hàng!', 'success');
                    } else {
                        updateCartCount(window.cartCount - 1); // Rollback nếu thất bại
                        showNotification(data.message || 'Có lỗi xảy ra', 'error');
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    updateCartCount(window.cartCount - 1); // Rollback nếu có lỗi
                    showNotification('Có lỗi xảy ra khi thêm vào giỏ hàng', 'error');
                });
        });
    });
});

// Hàm hiển thị thông báo
function showNotification(message, type = 'success') {
    const notification = document.createElement('div');
    notification.className = `notification ${type}`;
    notification.textContent = message;
    document.body.appendChild(notification);

    setTimeout(() => {
        notification.remove();
    }, 2000);
}