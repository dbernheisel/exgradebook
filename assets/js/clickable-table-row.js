$(document).ready(function() {
  $("tr.clickable").click(function() {
    window.location = $(this).data("href");
  });
});
