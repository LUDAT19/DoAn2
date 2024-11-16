document.addEventListener('DOMContentLoaded', function() {
    document.querySelectorAll('.lock-checkbox').forEach(function(checkbox) {
        checkbox.addEventListener('change', function() {
            const userId = this.dataset.userId;
            const statusBadge = document.getElementById(`status-badge-${userId}`);

            fetch(`/users/${userId}`, {
                    method: 'PATCH',
                    headers: {
                        'Content-Type': 'application/json',
                        'X-CSRF-Token': document.querySelector("[name='csrf-token']").content
                    },
                    body: JSON.stringify({
                        user: {
                            isclock: this.checked ? 0 : 1
                        }
                    })
                })
                .then(response => response.json())
                .then(data => {
                    statusBadge.textContent = data.text;
                    statusBadge.className = `badge ${data.badge_class}`;
                })
                .catch(error => {
                    console.error('Error:', error);
                    checkbox.checked = !checkbox.checked;
                });
        });
    });
});