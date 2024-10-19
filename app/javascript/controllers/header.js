document.addEventListener('turbo:load', () => {
  const button = document.getElementById('button');
  const bars = document.getElementById('bars');
  const menu = document.getElementById('menu');

  bars.classList.remove('hidden');

  button.addEventListener('click', event => {
    bars.classList.toggle('hidden');
    menu.classList.toggle('translate-x-full');
  });
});