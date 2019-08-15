// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require rails-ujs
//= require activestorage
//= require jquery3
//= require popper
//= require bootstrap
//= require bootstrap-editable
//= require dragula.min
//= require draggable
//= require_tree .

$(document).ready(function () {

  // Process draggable cards for drop event
  makeDraggable();

  // Frequently reloaded functions first-run
  initializeAfterAjax();

  // Processes buttons for creating blocks of lists
  $('.create-editable').editable({
    params: function (param) {
      return { name: param.value, return_block: true };
    },
    send: 'always',
    autotext: 'never',
    enablefocus: false,
    overwrite: false,
    highlight: false,
    success: onNewList
  });

});

function onNewList(data) {
  // Block'ś partial returned, add it to the page
  $('.no-content').remove();
  $(data).hide().prependTo('#card-drag-area').slideDown();
  initializeAfterAjax();
}

function makeDraggable() {
  dragula([document.getElementById('card-drag-area')]).on("drop", function(e) {
    //e.className += " card-moved"
    updateListsOrder();
  }).on("over", function(e, t) {
    //t.className += " card-over"
  }).on("out", function(e, t) {
    //t.className = t.className.replace("card-over", "")
  });
}

function updateListsOrder() {
  // TODO: AJAX PUT boards/:board_id/lists/order
}

function initializeAfterAjax() {
  // Process newly loaded icons
  feather.replace({ 'stroke': '#666', 'width': 22, 'height': 22 });

  // Processes editable heading texts
  $('.name-editable').editable({
    params: function (p) {
      return { name: p.value };
    },
    send: 'always'
  });

  // Add click event for block deletion
  $('.link-delete').bind('ajax:complete', function() {
    // Adds the 'no content' placeholder if there are no more blocks
    if ($('.list-block').length == 0) {
      $('#card-drag-area').prepend('<span class="no-content">No lists</span>');
    }

    // Removes the block
    $(this).closest('.list-block').fadeOut(300, function() { $(this).remove(); });
  });
}
