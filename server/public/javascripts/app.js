(function($){
  // Desenha tabuleiro
  $.fn.buildBoard = function(b) {
    return this.each(function(){
      var $this = $(this);
      $this.data("board", b);

      $.each(b, function(index, item){
          var $position = $("<div/>", { "class" : "position" });

          if(item[1] == "E"){
            var $state = $("<div/>", { "class" : "E" });
          } else if(item[1] == "O") {
            var $state = $("<div/>", { "class" : "O" });
          } else {
            var $state = $("<div/>", { "class" : "X" });
          }

          $state.data("state", item);
          $state.appendTo($position);
          $position.appendTo($this);
      })
    });
  }

  $.fn.setupFor = function(player, room_id, callback) {
    return this.each(function(){
        var $this = $(this);

        // Sends the board and the new state to the server
        $this.find(".E").click(function(){
          var url = "/" + room_id + "/play";
          var $state = $(this).data("state");
          var move = [[$state[0][0],$state[0][1]],player]
          var board = $.toJSON($this.data("board"));
          var data = {
            "board" : board
            ,"move" : $.toJSON(move)
          }

          $.post(url, data, function(result){
            callback(result);
          }, "json");
        });
    });
  }

  $.fn.startGame = function(options) {
    var config = {}
    var config = $.extend(options, config);

    return this.each(function(){
        $this = $(this);

        var callback = function(data){
          // When there is a winner
          if(data.hasOwnProperty("result")){
            var $disclaimer = $("<div/>", { "class" : "winner" });
            $disclaimer.html("Winner: " + data.result);
            $this.before($disclaimer);
            $this.find("> *").remove();
          }else{
            $this.find("> *").remove();
            $this.buildBoard(data);
            $this.setupFor(config.player, config.room_id, callback);
          }
        }

        $this.buildBoard(config.board);
        $this.setupFor(config.player, config.room_id, callback);
    });
  }

  $.fn.togglePlayer = function(){
    return this.each(function(){
        $this = $(this);
        $this.toggleClass("X")
    });
  }

  $.fn.multiplayer = function(options){
    var config = {}
    config = $.extend(options, config);

    return this.each(function(){
        $this = $(this);

        config.channel.bind("move", function(data){

          // When there is a winner
          if(data.hasOwnProperty("result")){
            var $disclaimer = $("<div/>", { "class" : "winner" });
            $disclaimer.html("Winner:");
            $disclaimer.addClass(data.result);
            $this.before($disclaimer);
            $this.find("> *").remove();
          }else{
            $this.find("> *").remove();
            $this.buildBoard(data);
            $this.setupFor(config.player, config.room_id, function(data){});
          }
        });

        $this.buildBoard(config.board);
        $this.setupFor(config.player, config.room_id, function(data){});
    });
  }

})( jQuery );
