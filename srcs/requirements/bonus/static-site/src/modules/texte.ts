export function initTextChange() {
    const button = document.getElementById("changerTexte") as HTMLButtonElement;
    const paragraph = document.getElementById("text-ts") as HTMLParagraphElement;
  
    button.addEventListener("click", () => {
      paragraph.textContent = "Le texte a été changé grâce à TypeScript !";
    });
  }
  