(function($){
  // Desenha tabuleiro
  $.fn.buildBoard = function(b) {
    return this.each(function(){
      var $this = $(this);
      $.each(b, function(index, item){
          var $position = $("<div/>", { "class" : "position" });
          if(item[1] == "E"){
            $position.append($("<div/>", { "class" : "empty" }));
          } else if(item[1] == "O") {
            $position.append($("<div/>", { "class" : "light" }));
          } else {
            $position.append($("<div/>", { "class" : "dark" }));
          }

          $position.appendTo($this);
      })
    });
  }


})( jQuery );
