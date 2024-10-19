window.toggleCheckboxes = function(checkbox) {
  const hasQualification = document.getElementById('has_qualification');
  const noQualification = document.getElementById('no_qualification');
  const selectQualification = document.getElementById('select_qualification');
  
  // チェックボックスの表示を切替(有 ↔️ 無)
  if (checkbox.id === 'has_qualification' && checkbox.checked) {
    noQualification.checked = false; // "無"を外す
    selectQualification.style.display = hasQualification.checked ? 'block' : 'none'; // 有がチェックされている場合は表示
  } else if (checkbox.id === 'no_qualification' && checkbox.checked) {
    hasQualification.checked = false; // "有"を外す
    selectQualification.style.display = noQualification.checked ? 'none' : 'block'; // 無がチェックされている場合は非表示
  }

};

document.addEventListener('DOMContentLoaded', function() {
  const hasQualification = document.getElementById('has_qualification');
  const selectQualification = document.getElementById('select_qualification');

  // ページロード時に「有」にチェックを入れる
  hasQualification.checked = true; // 「有」をチェック
  selectQualification.style.display = 'block'; // セレクトボックスを表示
});