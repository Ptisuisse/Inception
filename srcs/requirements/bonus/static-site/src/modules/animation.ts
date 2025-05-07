export function initAnimation() {
    const box = document.getElementById("ts-box") as HTMLDivElement;
    const button = document.getElementById("animer-box") as HTMLButtonElement;
  
    button.addEventListener("click", () => {
      let pos = 0;
      const max = 100;
      const duration = 1000;
      const start = performance.now();
  
      function animate(now: number) {
        const elapsed = now - start;
        const progress = Math.min(elapsed / duration, 1);
        pos = progress * max;
        box.style.transform = `translateX(${pos}px)`;
  
        if (progress < 1) requestAnimationFrame(animate);
      }
  
      requestAnimationFrame(animate);
    });
  }
  