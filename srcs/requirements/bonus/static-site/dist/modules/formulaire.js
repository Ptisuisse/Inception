export function initFormulaire() {
    const emailInput = document.getElementById("email-ts");
    const message = document.getElementById("validation-message");
    const envoyerBtn = document.getElementById("envoyer-ts");
    emailInput.addEventListener("input", () => {
        const value = emailInput.value;
        const valid = /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(value);
        if (valid) {
            message.textContent = "✅ Email valide";
            message.style.color = "green";
            envoyerBtn.disabled = false;
        }
        else {
            message.textContent = "❌ Email invalide";
            message.style.color = "red";
            envoyerBtn.disabled = true;
        }
    });
}
