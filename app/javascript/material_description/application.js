document.addEventListener('DOMContentLoaded', () => {
  const modal = document.getElementById('my_modal_5');
  document.querySelector('button[onclick="my_modal_5.showModal()"]').onclick = function() {
    modal.showModal();
  };
});