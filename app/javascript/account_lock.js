function submitLockForm(userId) {
    const form = document.getElementById(`lock-form-${userId}`);
    if (form) {
        form.requestSubmit();
    }
}

document.addEventListener('DOMContentLoaded', function() {
    // Ngăn chặn form submit thông thường để tránh refresh trang
    document.querySelectorAll('.lock-form').forEach(form => {
        form.addEventListener('submit', function(e) {
            e.preventDefault();

            const formData = new FormData(this);
            const userId = this.querySelector('.lock-checkbox').dataset.userId;

            fetch(this.action, {
                    method: 'PATCH',
                    headers: {
                        'X-CSRF-Token': document.querySelector("[name='csrf-token']").content,
                        'Accept': 'application/json'
                    },
                    body: formData
                })
                .then(response => response.json())
                .then(data => {
                    // Cập nhật UI
                    const badge = this.querySelector('.badge');
                    const checkbox = this.querySelector('.lock-checkbox');

                    if (checkbox.checked) {
                        badge.classList.remove('badge-success');
                        badge.classList.add('badge-danger');
                        badge.textContent = 'Đã khóa';
                    } else {
                        badge.classList.remove('badge-danger');
                        badge.classList.add('badge-success');
                        badge.textContent = 'Hoạt động';
                    }
                })
                .catch(error => console.error('Error:', error));
        });
    });
});