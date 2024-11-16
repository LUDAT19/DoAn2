document.addEventListener('turbo:load', () => {
    // Refresh trang sau khi update thành công
    if (document.querySelector('.alert-success')) {
        setTimeout(() => {
            window.location.reload();
        }, 100);
    }
});