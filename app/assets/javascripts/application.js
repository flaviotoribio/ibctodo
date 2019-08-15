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
//= require summernote
//= require summernote/summernote-bs4.min
//= require_tree .

var input_timer = [];
var input_delay = 750; // ms

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
    success: onNewList,
    error: function (xhr) {
      return 'Invalid name';
    }
  });

  // Processes buttons for creating new cards
  $('.create-card-editable').editable({
    params: function (param) {
      return { text: param.value, return_block: true };
    },
    send: 'always',
    autotext: 'never',
    enablefocus: false,
    overwrite: false,
    highlight: false,
    success: onNewCard,
    error: function (xhr) {
      return 'Invalid text';
    }
  });

});

function onNewList(data) {
  // Block's partial returned, add it to the page
  $('.no-content').remove();
  $(data).hide().prependTo('#card-drag-area').slideDown();
  initializeAfterAjax();
}

function onNewCard(data) {
  // Card's partial returned, add it to the block
  //$(data).hide().prependTo('#card-drag-area').slideDown();
  var container = $(this).closest('.card-content');
  $(data).hide().prependTo(container).slideDown();
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

  // Initialize summer note (WYSIWYG)
  $('[data-provider="summernote"]').each(function () {
    $(this).summernote({
      //height: 150,
      toolbar: false,
      lineHeight: 0.5,
      disableDragAndDrop: true,
      callbacks: {
        onInit: function () {
          $(this).closest('form').removeClass('invisible');
        },
        onChange: function(contents, $editable) {
          // Using URL as a unique key/hash for each timer
          var url = $editable.closest('form').attr('action');

          // A simple throbber system
          if (input_timer[url]) {
            clearTimeout(input_timer[url])
          }

          input_timer[url] = setTimeout(function (text, url) {
            input_timer[url] = undefined

            $.ajax({
              url: url,
              type: "PATCH",
              data: { text: text },
              success: function (data) {
                // discard
                // console.log("sucesso");
              },
              error: function (xhr, status, options) {
                // discard
                // console.log("erro");
              }
            });
          }.bind(null, contents, url), input_delay);
        }
      }
    });
  });

  // Processes editable heading texts
  $('.name-editable').editable({
    params: function (p) {
      return { name: p.value };
    },
    send: 'always'
  });

  // Add click event for list block deletion
  $('.list-delete').bind('ajax:complete', function (xhr, status, options) {
    // Adds the 'no content' placeholder if there are no more blocks
    if ($('.list-block').length == 0) {
      $('#card-drag-area').prepend('<span class="no-content">No lists.</span>');
    }

    // Removes the block
    $(this).closest('.list-block').fadeOut(300, function() { $(this).remove(); });
  });

  // Add click event for board block deletion
  $('.board-delete').bind('ajax:complete', function (xhr, status, options) {
    console.log("aaaa");
    // Adds the 'no content' placeholder if there are no more blocks
    if ($('.board-block').length == 0) {
      $('#card-drag-area').prepend('<span class="no-content">No boards.</span>');
    }

    // Removes the block
    $(this).closest('.board-block').fadeOut(300, function() { $(this).remove(); });
  });

  // Add click event for card block deletion
  $('.card-delete').bind('ajax:complete', function (xhr, status, options) {
    // Removes the block
    $(this).closest('.model-card').fadeOut(300, function() { $(this).remove(); });
  });
}
