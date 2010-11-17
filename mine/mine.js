function $ (element) {
    return document.getElementById(element);
}

(function mine_game() {

Vector = function (x, y) {
    this.x = x;
    this.y = y;
    
    this.toString = function (){
        return "x = " + x + ", y = " + y;
    }
}

Mine = function () {
    this.rows = $('rows').value || 10;
    this.cols = $('cols').value || 10;
    this.block_width = 30;
    this.mine_count = $('mines').value || 20;
    if(this.mine_count > this.rows*this.cols)
        this.mine_count = this.rows*this.cols-1;
    
    this.ctx = $('canvas').getContext('2d');
    this.canvas_width = $('canvas').width;
    this.canvas_height = $('canvas').height;
    this.canvas_x_offset =
        (this.canvas_width - this.block_width*this.rows)/2;
    this.canvas_y_offset =
        (this.canvas_height - this.block_width*this.cols)/2;
    
    this.last_block_over;
    this.blocks = this.makeBlocks();
    
    this.draw_map(this.ctx);
    
    console.log(this);
};

Mine.prototype.draw_map = function (ctx) {
    for(i=0; i<this.rows; i++){
        for(j=0; j<this.cols; j++){
            ctx.strokeRect(
                this.block_width*i + this.canvas_x_offset,
                this.block_width*j + this.canvas_y_offset,
                this.block_width,
                this.block_width
            );
        }
    }
}

Mine.prototype.clear = function () {
    this.ctx.clearRect(
        0,0,400,400
    );
}

Block = function (game, x, y) {
    // game reference
    this.ref = game;
    
    // block coordenation
    this.coor = new Vector(x, y);
    
    this.clicked = false;
    this.flagged = false;
    this.over = false;
    this.mined = false;
    this.number = 0;
    this.neightboors;
    
    this.write = function () {
        to_write = '';
        if(this.mined)
            to_write = 'B';
        else
            to_write = this.number;
        this.ref.ctx.save();
        this.ref.ctx.font = "25px Arial";
        this.ref.ctx.fillStyle = 'blue';
        this.ref.ctx.fillText(
            to_write,
            this.coor.x*this.ref.block_width + this.ref.canvas_x_offset + 5,
            this.coor.y*this.ref.block_width + this.ref.canvas_y_offset + 25
        );
        this.ref.ctx.restore();
        this.clicked = true;
    }
    
    this.flag = function () {
        this.flagged = true;
        to_write = 'F';
        this.ref.ctx.save();
        this.ref.ctx.font = "25px Arial";
        this.ref.ctx.fillStyle = 'blue';
        this.ref.ctx.fillText(
            to_write,
            this.coor.x*this.ref.block_width + this.ref.canvas_x_offset + 5,
            this.coor.y*this.ref.block_width + this.ref.canvas_y_offset + 25
        );
        this.ref.ctx.restore();
    }
    
    // highlight or no
    this.turn_on = function () {
        if(this.clicked) return;
        this.ref.ctx.save();
        this.ref.ctx.fillStyle = 'black';
        this.ref.ctx.fillRect(
            this.coor.x*this.ref.block_width + this.ref.canvas_x_offset,
            this.coor.y*this.ref.block_width + this.ref.canvas_y_offset,
            this.ref.block_width,
            this.ref.block_width
        );
        this.ref.ctx.restore();
    }
    
    this.turn_off = function () {
        this.ref.ctx.save();
        this.ref.ctx.fillStyle = 'white';
        this.ref.ctx.fillRect(
            this.coor.x*this.ref.block_width + this.ref.canvas_x_offset,
            this.coor.y*this.ref.block_width + this.ref.canvas_y_offset,
            this.ref.block_width,
            this.ref.block_width
        );
        this.ref.ctx.strokeRect(
            this.coor.x*this.ref.block_width + this.ref.canvas_x_offset,
            this.coor.y*this.ref.block_width + this.ref.canvas_y_offset,
            this.ref.block_width,
            this.ref.block_width
        );
        this.ref.ctx.restore();
        if(this.clicked)
            this.write();
        if(this.flagged)
            this.flag();
    }
    
    this.toString = function() {
        return this.coor.toString();
    }
}

Block.prototype.makeNeightboors = function (blocks) {
    game = this.ref;
    coor = this.coor;
    
    this.neightboors = [];
    neightboors = this.neightboors;
    
    // get top neightboor
    if(coor.y-1 >= 0) {
        neightboors.push(blocks[coor.x][coor.y-1]);
        if(coor.x-1 >= 0)
            neightboors.push(blocks[coor.x-1][coor.y-1]);
        if(coor.x+1 < game.rows)
            neightboors.push(blocks[coor.x+1][coor.y-1]);
    }
    
    // get left and right neightboors
    if(coor.x-1 >= 0)
        neightboors.push(blocks[coor.x-1][coor.y]);
    if(coor.x+1 < game.rows)
        neightboors.push(blocks[coor.x+1][coor.y]);
    
    // get bottom neightboor
    if(coor.y+1 < game.cols) {
        neightboors.push(blocks[coor.x][coor.y+1]);
        if(coor.x-1 >= 0)
            neightboors.push(blocks[coor.x-1][coor.y+1]);
        if(coor.x+1 < game.rows)
            neightboors.push(blocks[coor.x+1][coor.y+1]);
    }
}

Block.prototype.revealNeightboors = function () {
    // conta quantas bandeiras foram colocadas
    var bombs = 0, wrong_mark = false;
    for(n in this.neightboors){
        if(this.neightboors[n].flagged){
            bombs++;
            if(!this.neightboors[n].mined)
                wrong_mark = true;
        }
    }
    
    if(bombs >= this.number && wrong_mark){
        this.ref.gameover();        // game over
        return;
    }
    
    if(bombs == this.number){
        for(n in this.neightboors){
            if(!this.neightboors[n].mined)
                this.neightboors[n].write();
        }
    }
}

Mine.prototype.mapCanvas = function(e) {
    mouse_coor = new Vector(e.offsetX, e.offsetY);
    
    block = this.getBlockByCoor(mouse_coor);
    if(block == null){
        if(this.last_block_over != null)
            this.last_block_over.turn_off();
    }
    else {
        if(!block.clicked && !block.flagged){
            block.turn_on();
            if(block != this.last_block_over) {
                if(this.last_block_over != null)
                    this.last_block_over.turn_off();
                this.last_block_over = block;
            }
        }
    }
}

Mine.prototype.mapClick = function(e) {
    mouse_coor = new Vector(e.offsetX, e.offsetY);
        
    block = this.getBlockByCoor(mouse_coor);
    if(block != null){
        if(!block.clicked){
            block.clicked = true;
            block.write();
        }
        else {
            block.revealNeightboors();
        }
    }
}

Mine.prototype.mapFlag = function(e) {
    mouse_coor = new Vector(e.offsetX, e.offsetY);
        
    block = this.getBlockByCoor(mouse_coor);
    if(block != null){
        block.flag();
    }
}

Mine.prototype.makeBlocks = function() {
    var blocks = [];
    var to_mine = [];
    
    // inicia os blocos e cria o vetor que pode ter as minas
    for(i=0; i<this.rows; i++){
        blocks[i] = [];
        for(j=0; j<this.cols; j++){
            blocks[i][j] = new Block(this,i,j);
            to_mine.push(blocks[i][j]);
        }
    }
    
    // inicia os vizinhos dos blocos
    for(i=0; i<this.rows; i++){
        for(j=0; j<this.cols; j++){
            blocks[i][j].makeNeightboors(blocks);
        }
    }
    
    for(i=0; i<this.mine_count; i++){
        mine_place = Math.floor(Math.random()*to_mine.length);
        mined = to_mine[mine_place];
        mined.mined = true;
        for(n in mined.neightboors)
            mined.neightboors[n].number++;
        to_mine.splice(mine_place, 1);
    }
    
    return blocks;
}

Mine.prototype.getBlockByCoor = function (coor) {
    x = coor.x - this.canvas_x_offset;
    y = coor.y - this.canvas_y_offset;
    
    vector = new Vector(x, y);
    
    row = parseInt(vector.x / this.block_width);
    col = parseInt(vector.y / this.block_width);
    
    if(row >= 0 && col >= 0 && row < this.rows
        && col < this.cols)
        return this.blocks[row][col];
    else
        return null;
}

}());

function fieldsVerify() {
    fields = ['rows', 'cols', 'mines'];
    for(i in fields){
        if($(fields[i]).value <= 0){
            $(fields[i]).value = 1;
        }
        if(fields[i] != 'mines' && $(fields[i]).value > 13){
            $(fields[i]).value = 13;
        }
    }
}

window.onload = function () {
    mine = new Mine();
    $('canvas').addEventListener('mousemove', function (e) {
        mine.mapCanvas.call(mine, e);
    }, false);
    $('canvas').addEventListener('click', function (e) {
        mine.mapClick.call(mine, e);
    }, false);
    $('canvas').addEventListener('contextmenu', function (e) {
        mine.mapFlag.call(mine, e);
        e.cancelBubble = true;
        e.stopPropagation();
        e.preventDefault();
    }, false);
    $('go').onclick = function (e) {
        mine.clear();
        fieldsVerify();
        mine = new Mine();
    }
}