// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require_tree .

$(function() {
  var updateRecipes = function(profession, level) {
    recipes = $('div[data-profession="' + profession + '"]');
    recipes.each(function() {
      var self = $(this);
      if (self.data('level') > level) {
        self.hide();
      } else {
        self.show();
      }
    });
  };

  var updateCounter = function() {
    var rollover = updateTime('seconds', 60);
    if (rollover) {
      rollover = updateTime('minutes', 60);
      if (rollover) {
        updateTime('hours', 0);
      }
    }
  };

  // timeUnit: One of: hours, minutes, or seconds
  // rollover: the value at which the unit of time rolls over, or 0 for no rollover
  // Returns: true if a rollover occured, false otherwise
  var updateTime = function(timeUnit, rollover) {
    rollover = typeof rollover !== 'undefined' ? rollover : 0;

    var span = $('#' + timeUnit + '_since_update').show();
    var timeValue = parseInt(span.children('.value').text(), 10) + 1;
    var newValue = rollover === 0 ? timeValue : timeValue % rollover;

    span.children('.value').text(newValue);

    if (newValue === 1) {
      span.children('.plural').hide();
    } else {
      span.children('.plural').show();
    }

    return newValue === 0;
  };

  // Count up the 'updated_at' counter
  setInterval(function() { updateCounter(); }, 1000);

  $('input').change(function(input) {
    var self = $(this)[0];
    profession = self.name;
    level = self.value;
    localStorage.setItem(profession + "_level", level);
    updateRecipes(profession, level);
  });

  $('input').each(function() {
    var self = $(this);
    var profession = self.attr('name');
    var level = localStorage.getItem(profession + "_level");
    if (level === null) {
      level = 400;
    }
    self.attr('value', level);
    updateRecipes(profession, level);
  });
});
