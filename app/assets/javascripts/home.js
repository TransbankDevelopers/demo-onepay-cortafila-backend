// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

$(document).ready(function() {
  $("body").css({"overflow":"hidden"});

  $('#pay-button').click(function() {
    $('#paymentModal').modal();
  });

  $('#paymentModal').on('show.bs.modal', function(e) {
    new QRCode(document.getElementById("payment-qr"), {
      text: "onepay=ott:12345678",
      width: 150,
      height: 150,
      colorDark : "#000000",
      colorLight : "#ffffff",
      correctLevel : QRCode.CorrectLevel.H
    });
  });

  $('#paymentModal').on('hidden.bs.modal', function(e) {
    $('#payment-qr').empty();
  });

  $('.checkbox-item').change(function(e) {
    let totalItem = $('#totalItems');
    let price = $(this).data("price")

    if (this.checked) {
      totalItem.text(parseInt(totalItem.text()) + parseInt(price));
    } else {
      totalItem.text(parseInt(totalItem.text()) - parseInt(price));
    }
  });
});
