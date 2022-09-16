// $(window).on('load',function(){
//   $("#loading").delay(1500).fadeOut('slow');//ローディング画面を1.5秒（1500ms）待機してからフェードアウト
//   $("#loading_box").delay(1200).fadeOut('slow');//ローディングテキストを1.2秒（1200ms）待機してからフェードアウト
// });
$('head').append(
  '<style type="text/css">body {display:none;}'
);
$(document).on('load', function() {
  $('body').delay(600).fadeIn("slow");

});