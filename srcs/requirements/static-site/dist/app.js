"use strict";
/**
 * Script principal pour le site statique.
 */
// Affiche un message dans la console de développement du navigateur
// pour vérifier que le script est bien chargé et exécuté.
console.log("Le script app.ts (compilé en app.js) est en cours d'exécution !");
// Récupère l'élément HTML qui a l'identifiant (id) "message".
// TypeScript sait que getElementById peut retourner HTMLElement ou null,
// donc nous devons vérifier si l'élément existe.
const messageParagraph = document.getElementById('message');
// Vérifie si l'élément a été trouvé dans le document HTML.
if (messageParagraph) {
    // Si l'élément existe, on modifie son contenu textuel.
    // textContent est la propriété standard pour changer le texte d'un élément.
    messageParagraph.textContent = 'Bonjour ! Ce message a été défini dynamiquement par TypeScript.';
    // Optionnel : On pourrait aussi changer son style ou ajouter une classe
    // messageParagraph.style.color = 'green';
    // messageParagraph.style.fontStyle = 'normal';
    // messageParagraph.classList.add('message-updated'); // Si vous aviez défini .message-updated en CSS
    console.log("Le contenu du paragraphe #message a été modifié.");
}
else {
    // Si l'élément n'a pas été trouvé, affiche une erreur dans la console.
    console.error("L'élément avec l'ID 'message' n'a pas été trouvé dans le HTML.");
}
// Vous pouvez ajouter d'autres logiques ici si nécessaire.
// Par exemple, ajouter des écouteurs d'événements sur des boutons, etc.
//# sourceMappingURL=app.js.map