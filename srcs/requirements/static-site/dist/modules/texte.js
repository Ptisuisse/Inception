export function initTextChange() {
    const button = document.getElementById("changerTexte");
    const paragraph = document.getElementById("text-ts");
    button.addEventListener("click", () => {
        paragraph.textContent = "Le texte a été changé grâce à TypeScript !";
    });
}
