(function define_game() {

/** ---------------------- Helpers ------------------------------- */
h = {

    /**
     * Helper to make vetor objects
     */
    v: function(x, y){ return {x: x, y: y}; }
    
}

/** ---------------------- Helpers-emd --------------------------- */

/**
 * Code layout based on
 * http://lostdecadegamesapp.appspot.com/
 */

const VERSION = "0.0.1";
const DIFFICULTY_INCREMENT = 1;
const COLS = 9;
const LINES = 20;
const BWIDTH = 20;

tetris = {};

/**
 * Get canvas element
 */
tetris.ctx;

/**
 * Environment
 * Manage the game
 */
tetris.Environment = function tetris_Environment () {
    this.piece;
}

var proto = tetris.Environment.prototype;

proto.init = function tetris_Environment_init () {
    tetris.Timeout(1000, this.gameLoop, this);
}

proto.draw = function tetris_Environment_draw (ctx) {
    ctx.clearRect(0, 0, 350, 400);
    var piece = this.piece;
    
    for(j in piece.body){
        var b = piece.body[j];
        var x = (piece.position.x + b.x) * BWIDTH;
        var y = (piece.position.y + b.y) * BWIDTH;
        ctx.fillRect(
            (piece.position.x + b.x) * BWIDTH,
            (piece.position.y + b.y) * BWIDTH,
            BWIDTH,
            BWIDTH
        );
    }
}

proto.gameLoop = function tetris_Environment_gameLoop () {
    this.piece.move();
    console.log(this.piece);
    this.draw(tetris.ctx);
}

/** ---------------------- Environment-End ----------------------- */


/** ---------------------- Piece objects ------------------------- */
tetris.Piece = function tetris_Piece (body, width, height) {
    this.body = body;
    this.width = width;
    this.height = height;
    this.position = {x: 5, y: 0};
    this.move = function () {
        console.log(this.position.y);
        this.position.y++;
        console.log(this.position.y);
    };
    this.rotate;
    this.arotate;
    this.toString = function () {
        return this.body + ", " + this.position
    };
}

tetris.Piece.type = {
    
    L: {
        body: [h.v(0, 0), h.v(0, 1), h.v(0, 2), h.v(1, 2)],
        width: 2,
        height: 3
    },
    
    BLOCK: {
        body: [h.v(0, 0), h.v(1, 0), h.v(0, 1), h.v(1, 1)],
        width: 2,
        height: 2
    },
    
    ANTIL: {
        body: [h.v(1, 0), h.v(1, 1), h.v(0, 2), h.v(1, 2)],
        width: 2,
        height: 3
    },
    
    T: {
        body: [h.v(1, 0), h.v(0, 1), h.v(1, 1), h.v(2, 1)],
        width: 3,
        height: 2
    },
    
    LINE: {
        body: [h.v(0, 0), h.v(0, 1), h.v(0, 2), h.v(0, 3)],
        width: 1,
        height: 4
    }
}

tetris.key = {
    left:   37,
    up:     38,
    right:  39,
    down:   40
};

tetris.Timeout = function tetris_Timeout (time, fn, context) {
    var f = function timeout_anon () {
        fn.call(context);
    }
    return window.setInterval(f, time);
}

}());

window.onload = function () {
    tetris.ctx = document.getElementById('canvas').getContext('2d');
    var e = new tetris.Environment();
    e.piece = new tetris.Piece(
        tetris.Piece.type.LINE.body,
        tetris.Piece.type.LINE.width,
        tetris.Piece.type.LINE.height
    );
    e.init();
}
