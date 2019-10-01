document.addEventListener('DOMContentLoaded', () => {
  const todoDescriptions = document.querySelectorAll('.todo-description');
  const todoTitles = document.querySelectorAll('.todo-title');
  todoTitles.forEach(el => {
    el.addEventListener('click', () =>{
      const id = el.dataset.id;
      const desc = Array
                     .from(todoDescriptions)
                     .filter(el => el.dataset.id === id)[0];
      desc.classList.toggle('hidden');
    });
  });
});
