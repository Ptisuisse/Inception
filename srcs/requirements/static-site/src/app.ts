import { initTextChange } from './modules/texte.js';
import { initCompteur } from './modules/compteur.js';
import { initFormulaire } from './modules/formulaire.js';
import { initAnimation } from './modules/animation.js';

document.addEventListener("DOMContentLoaded", () => {
  initTextChange();
  initCompteur();
  initFormulaire();
  initAnimation();
});
