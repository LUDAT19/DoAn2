document.addEventListener('DOMContentLoaded', function() {
    // Xử lý click cho tất cả các submenu-link
    document.querySelectorAll('.submenu-link').forEach(link => {
        link.addEventListener('click', function(e) {
            e.preventDefault();

            fetch(this.href)
                .then(response => response.text())
                .then(html => {
                    document.getElementById('content-container').innerHTML = html;
                });
        });
    });
});