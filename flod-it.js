function Vector (x, y){
    this.x = x || 0;
    this.y = y || 0;
    this.size;
    
    this.toString = function(){
        return "x: " + this.x + ", y: " + this.y;
    }
}

function BlockGroup(nBlocks, bWidth) {
    this.nBlocks = nBlocks;
    this.blocks = [];
    
    var ml = 100; // margin-left
    
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
        ctx.clearRect(100, 0, 500, 500);
        for(var i=0; i<this.blocks.length; i++){
            for(var j=0; j<this.blocks[i].length; j++){
                var b = this.blocks[i][j];
                //log(b.toString());
                //log(i*b.width +", "+ j*b.height +", "+ b.width +", "+ b.height +", "+ b.color);
                dRect(ctx, i*b.size+ml, j*b.size, b.size, b.size, b.color);
            }
        }
    };
    
    this.suffle = function(){
        for(var i=0; i<nBlocks; i++){
            for(var j=0; j<nBlocks; j++){
                var color = colors[Math.floor(Math.random()*colors.length)];
                this.blocks[i][j].color = color;
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
    
    // test
    this.suffle();
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
    
    this.getX = function(){ return this.pos.x; }
    this.getY = function(){ return this.pos.y; }
    
    this.toString = function(){
        return this.size + ", " + this.color + ", " + this.width + ", " + this.height + ", " + this.pos.toString();
    }
}

function Menu(colors){
    this.menus = [];
    this.over  = false;
    
    var size = 50;
    var mt   = 25; //margin-top
    var ml   = 15; //margin-left

    for(i=0; i < colors.length; i++){
        this.menus[i] = new Block(new Vector(ml, i*size+(mt*(i+1))), size, colors[i]);
        this.menus[i].selected = false;
    }
    
    this.draw = function() {
        for(i in this.menus){
            tp = this.menus[i];
            if(!tp.selected){
                dRect(ctx, tp.getX(), tp.getY(), tp.size, tp.size, tp.color);
            }
            else{
                ctx.save();
                ctx.fillStyle = "#000";
                ctx.lineWidth = 3;
                ctx.strokeRect(tp.getX()+2, tp.getY()+2, tp.size-4, tp.size-4);
                ctx.restore();
                
            }
        }
    }
    
    this.isOver = function(mouseCoords){
        
        x = mouseCoords.x;
        y = mouseCoords.y;
        for(var i=0; i<this.menus.length; i++){

            if(x > this.menus[i].getX() && x < this.menus[i].getX() + this.menus[i].size &&
                y > this.menus[i].getY() && y < this.menus[i].getY() + this.menus[i].size){
                
                this.menus[i].selected = true;
                if(!this.over) this.draw();
                
                this.over = true;
                return this.menus[i];
            }
            this.menus[i].selected = false;
        }
        if(this.over) this.draw();
        this.over = false;
    }
}

function dRect(ctx, x, y, w, h, color){
    ctx.fillStyle = color;
    ctx.fillRect(x, y, w, h);
}

var menu;
var nBlocks = 14;
var block_width = Math.ceil(500/14);
var ctx;
var colors = ['#33FF00', '#6600FF', '#FFFF00', '#FF0000', '#66FFFF', "#FF00FF"];
var bGroup;

window.onload = function() {
    
    ctx = $("canvas").getContext("2d");

    // improve
    bGroup = new BlockGroup(nBlocks, block_width);
    bGroup.suffle();
    
    menu = new Menu(colors);
    menu.draw();

    bGroup.draw();
};

function getMouseCoords(e){
    var c_offset = canvasPosition(); 
    
    var result = new Vector(e.pageX - c_offset.x, e.pageY - c_offset.y);
    return result;
}

function canvasPosition(){
    return new Vector($("canvas").offsetLeft, $("canvas").offsetTop);
}

document.onmousedown = function(e){
    // improve this
    var click_coord = getMouseCoords(e);
    var selected;

    selected = menu.isOver(click_coord);

    if(selected != null){
        flodit(selected.color);
    }
}

document.onmousemove = function (event) {
    var mouseCoords = getMouseCoords(event);
    
    menu.isOver(mouseCoords);
}

function flodit(newColor){
    // resta os blocos pintados
    bGroup.reset();

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
    
}

function $ (el){ return document.getElementById(el); }
function log (msg) { $("log").innerHTML = msg + "<br>" + $("log").innerHTML; }
