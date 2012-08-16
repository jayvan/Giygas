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
  $(function() {
    

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
      if (level == null) {
        level = 0;
      }
      self.attr('value', level);
      updateRecipes(profession, level);
    });
  });
