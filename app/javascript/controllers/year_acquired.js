document.addEventListener('turbo:load', function() {
  const progressSelect = document.getElementById("progress-select");
  const yearAcquiredDiv = document.getElementById("year-acquired-container");
  function toggleYearAcquiredVisibility() {
    if (progressSelect.value === '合格') {
      yearAcquiredDiv.style.display = 'block';
    } else {
      yearAcquiredDiv.style.display = 'none';
    }
  }

  // 初期表示
  toggleYearAcquiredVisibility();

  // 進捗状況が変更されたときの処理 
  progressSelect.addEventListener('change', toggleYearAcquiredVisibility);
});