function Vector (x, y){
    this.x = x || 0;
    this.y = y || 0;
    this.size;
}

function BlockGroup(nBlocks, bWidth) {
    this.nBlocks = nBlocks;
    this.blocks = [];
    
    for(i=0; i < nBlocks; i++){
        this.blocks[i] = [];
        for(j=0; j < nBlocks;j++){
            p = new Vector(i,j);
            
            this.blocks[i][j] = new Block(p, bWidth);
        }
    }
    
    this.add = function(b){
        blocks.push(b);
    };
    
    this.get = function(x,y){
        if(x < 0 || x > this.nBlocks-1 || y < 0 || y > this.nBlocks-1 )
            return null;
        
        return this.blocks[x][y];
    };
    
    this.draw = function(){
        // improve this...
        ctx.clearRect(0, 0, 500, 500);
        for(var i=0; i<this.blocks.length; i++){
            for(var j=0; j<this.blocks[i].length; j++){
                var b = this.blocks[i][j];
                //log(b.toString());
                //log(i*b.width +", "+ j*b.height +", "+ b.width +", "+ b.height +", "+ b.color);
                dRect(ctx, i*b.size, j*b.size, b.size, b.size, b.color);
            }
        }
    };
    
    this.reset = function(){
        for(i=0; i < this.blocks.length; i++){
            for(j=0; j < this.blocks[i].length; j++){
                this.blocks[i][j].painted = false;
            }
        }
    };
}

function Block(pos, size, color){
    this.pos     = pos;
    this.size    = size;
    this.color   = color || "#fff";
    this.painted = false;
    
    this.width   = this.pos.x + size;
    this.height  = this.pos.y + size;
    
    this.getNeighbors = function(){
        result = [new Vector(this.pos.x+1, this.pos.y),
            new Vector(this.pos.x-1, this.pos.y),
            new Vector(this.pos.x  , this.pos.y+1),
            new Vector(this.pos.x  , this.pos.y-1)];
            
        return result;
    }
    
    this.toString = function(){
        return this.size + ", " + this.color + ", " + this.width + ", " + this.height;
    }
}

function $ (el){ return document.getElementById(el); }
function log (msg) { $("log").innerHTML = msg + "<br>" + $("log").innerHTML; }

function dRect(ctx, x, y, w, h, color){
    ctx.fillStyle = color;
    ctx.fillRect(x, y, w, h);
}

var blocks_array = [];
var blocks_painted = [];
var menu = [];
var nBlocks = 10;
var block_width = 50;
var ctx;
var colors = ['#33FF00', '#6600FF', '#FFFF00', '#FF0000', '#66FFFF'];
var bGroup;

window.onload = function() {
    
    ctx = $("canvas").getContext("2d");

    // improve
    bGroup = new BlockGroup(nBlocks, 50);
    
    for(var i=0; i<nBlocks; i++){
        // remove
        blocks_array[i] = [];
        blocks_painted[i] = [];
        
        for(var j=0; j<nBlocks; j++){
            var color = colors[Math.floor(Math.random()*colors.length)];
            bGroup.get(i,j).color = color;
            
            // remove
            blocks_array[i][j] = color;
            blocks_painted[i][j] = false;
        }
    }

    // menu builder, move this to a function
    for(var i=0; i<colors.length; i++){
        menu[i] = new Vector();
        menu[i].x = 525;
        menu[i].y = (i*50)+((1+i)*10);
        menu[i].size = block_width;

        dRect(ctx, 525, menu[i].y, block_width, block_width, colors[i]);
    }

    bGroup.draw();
};

/*/ remove
function draw(){
    ctx.clearRect(0, 0, 500, 500);
    for(var i=0; i<nBlocks; i++){
        for(var j=0; j<nBlocks; j++){
            dRect(ctx, i*block_width, j*block_width, block_width, block_width, blocks_array[i][j]);
        }
    }
}
*/

function getClickCoord(e){
    var c_offset = canvasPosition(); 
    
    var result = new Vector(e.pageX - c_offset.x, e.pageY - c_offset.y);
    //var result = new Vector(e.pageX, e.pageY);
    return result;
}

function canvasPosition(){
    return new Vector($("canvas").offsetLeft, $("canvas").offsetTop);
}

document.onmousedown = function(e){
    // improve this
    var click_coord = getClickCoord(e);
    var selected;

    for(var i=0; i<menu.length; i++){
        x = click_coord.x;
        y = click_coord.y;

        if(x > menu[i].x && x < menu[i].x + menu[i].size &&
            y > menu[i].y && y < menu[i].y + menu[i].size){

            selected = colors[i];
            break;
        }
    }

    if(selected != null){
        flodit(selected);
        log(selected);
    }
}

function flodit(newColor){
    // resta os blocos pintados
    bGroup.reset();
    /*/ remove
    for(var i=0; i<blocks_painted.length; i++){
        for(var j=0; j<blocks_painted.length; j++){
            blocks_painted[i][j] = false;
        }
    }
    blocks_painted[0][0] = true;
    */

    var bCurrent;
    var bStack = [bGroup.get(0, 0)];
    
    while(bStack.length > 0){
        bCurrent = bStack.pop();
        
        neighbors = bCurrent.getNeighbors();
        for(i in neighbors){
            neighbor = bGroup.get(neighbors[i].x, neighbors[i].y);
            if(neighbor && !neighbor.painted){
                if(neighbor.color == bCurrent.color)
                    bStack.push(neighbor);
            }
        }
        
        bCurrent.color = newColor;
        bCurrent.painted = true;
    }
    
    bGroup.draw();
    
    /*
    var cor = blocks_array[0][0];
    var same_color = [new Vector(0, 0)];
    var flooded = [];

    for(var b=0; b<same_color.length; b++) {
            // pega vizinhos
            x = same_color[b].x;
            y = same_color[b].y;

            if(x>0)
                if(blocks_array[x-1][y] == cor && !blocks_painted[x-1][y]){
                    same_color.push(new Vector(x-1, y));
                    blocks_painted[x-1][y] = true;
                }
                else if(blocks_array[x-1][y] == newColor)
                    flooded.push(new Vector(x-1, y));

            if(x<blocks_array.length-1)
                if(blocks_array[x+1][y] == cor && !blocks_painted[x+1][y]){
                    same_color.push(new Vector(x+1, y));
                    blocks_painted[x+1][y] = true;
                }
                else if(blocks_array[x+1][y] == newColor)
                    flooded.push(new Vector(x+1, y));

            if(y>0)
                if(blocks_array[x][y-1] == cor && !blocks_painted[x][y-1]){
                    same_color.push(new Vector(x, y-1));
                    blocks_painted[x][y-1] = true;
                }
                else if(blocks_array[x][y-1] == newColor)
                    flooded.push(new Vector(x, y-1));

            if(y<blocks_array[x].length-1)
                if(blocks_array[x][y+1] == cor && !blocks_painted[x][y+1]){
                    same_color.push(new Vector(x, y+1));
                    blocks_painted[x][y+1] = true;
                }
                else if(blocks_array[x][y+1] == newColor)
                    flooded.push(new Vector(x, y+1));

            blocks_array[x][y] = newColor;
    }
    for(b in flooded){
        blocks_array[flooded[b].x][flooded[b].y] = newColor;
    }

    draw();
    */
}
