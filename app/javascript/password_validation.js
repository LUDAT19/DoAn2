document.addEventListener('DOMContentLoaded', function() {
    const passwordField = document.querySelector('input[name="user[password_pidget]"]');
    const validationMessage = document.createElement('div');
    validationMessage.className = 'password-validation-message';

    if (passwordField) {
        passwordField.after(validationMessage);

        passwordField.addEventListener('input', function() {
            const password = this.value;
            const requirements = [{
                    regex: /.{8,}/,
                    message: 'Ít nhất 8 ký tự'
                },
                {
                    regex: /[A-Z]/,
                    message: 'Ít nhất 1 chữ in hoa'
                },
                {
                    regex: /[!@#$%^&*]/,
                    message: 'Ít nhất 1 ký tự đặc biệt (!@#$%^&*)'
                }
            ];

            let validationHTML = '<ul class="password-requirements">';
            let allValid = true;

            requirements.forEach(requirement => {
                const isValid = requirement.regex.test(password);
                const itemClass = isValid ? 'valid' : 'invalid';
                validationHTML += `
          <li class="${itemClass}">
            <span class="icon">${isValid ? '✓' : '✗'}</span>
            ${requirement.message}
          </li>
        `;
                if (!isValid) allValid = false;
            });

            validationHTML += '</ul>';
            validationMessage.innerHTML = validationHTML;

            // Thêm/xóa class cho password field
            if (password.length > 0) {
                passwordField.classList.toggle('valid', allValid);
                passwordField.classList.toggle('invalid', !allValid);
            } else {
                passwordField.classList.remove('valid', 'invalid');
            }
        });
    }
});