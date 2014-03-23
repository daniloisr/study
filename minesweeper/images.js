(function image_factory() {

ImagesFactory = function (ctx) {
    this.image = $('images-all');
    this.ctx = ctx;
    this.get = function (request) {
        switch(request) {
        case 'normal':
            return {
                x: 0,
                y: 0,
                xwidth: 400,
                ywidth: 400
            };
            break;

        case 'hover':
            return {
                x: 400,
                y: 0,
                xwidth: 400,
                ywidth: 400
            };
            break;

        case 'flag':
            return {
                x: 1600,
                y: 0,
                xwidth: 400,
                ywidth: 400
            };
            break;

        case 'mine':
            return {
                x: 1200,
                y: 0,
                xwidth: 400,
                ywidth: 400
            };
            break;

        case 'number':
            var r = [];
            r.push({
                x: 800,
                y: 0,
                xwidth: 400,
                ywidth: 400,
            });
            for(var i = 0; i < 8; i++) {
                r.push({
                    x: 2000 + i*400,
                    y: 0,
                    xwidth: 400,
                    ywidth: 400,
                });
            }
            return r;
        }
    };

    this.draw = function(image, x, y, width, height){
        this.ctx.drawImage(
            this.image,
            image.x,
            image.y,
            image.xwidth,
            image.ywidth,
            x, y, width, height
        );
    }

    this.drawBlock = function(image, block){
        this.ctx.drawImage(
            this.image,
            image.x,
            image.y,
            image.xwidth,
            image.ywidth,
            block.coor.x*block.ref.block_width + block.ref.canvas_x_offset,
            block.coor.y*block.ref.block_width + block.ref.canvas_y_offset,
            block.ref.block_width,
            block.ref.block_width
        );
    }
}

}());
