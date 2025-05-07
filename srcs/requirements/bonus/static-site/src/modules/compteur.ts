export function initCompteur() {
    const compteurSpan = document.getElementById("compteur")!;
    const button = document.getElementById("incremente")!;
  
    let count = 0;
    button.addEventListener("click", () => {
      count++;
      compteurSpan.textContent = count.toString();
    });
  }
  