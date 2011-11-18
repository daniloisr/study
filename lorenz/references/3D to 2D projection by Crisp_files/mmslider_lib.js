function MMSlider(width,height,headline,content){
    this.timer = null;
    this.speed = 6; //1 is  slow
    this.endTop = 0;
    this.endLeft = 0;
    this.width = width;
    this.height = height;
    this.headline = headline;
    this.content = content;

    function moveEl(id) {
	    var popup = document.getElementById(id);
	    var currentTop = parseInt(popup.offsetTop);
	    var currentLeft = parseInt(popup.offsetLeft);
	
	    var keepMoving = false;
	    //Move
	    if (currentTop < this.endTop) {
		    popup.style.top = (currentTop + this.speed) + "px";
		    keepMoving = true;
	    }
	    if(currentLeft < this.endLeft) {	
		    popup.style.left = (currentLeft + this.speed) + "px";
		    keepMoving = true;
	    }
	    if (keepMoving) {
		    this.continueMove(id);
	    } else {
		    this.endMove();
	    }
    }

    function hideEl(id) {
	    document.getElementById(id).style.display ="none";
    }

    function continueMove(id) {
        var _self = this;
	    this.timer = setTimeout(function(ms){_self.moveEl(id)}, 1);
    }

    function startMove() {
        var now = new Date().getTime();
        var ypos;
        var id = 'mmsliderpopup';

        if( !isCapped([3,86400]) ) {
            this.insertSliderCSS();
            this.insertSliderHTML();
//            ypos = (this.getWindowHeight() / 2) - parseInt(this.height / 2);
            ypos = 100;
            document.getElementById(id).style.top = ypos + "px";
/*            document.getElementById(id).style.left = "-" + this.width + "px";*/
            document.getElementById(id).style.left = "0px";
            document.getElementById(id).style.display ="";
/*            this.continueMove(id);*/
        }
    }

    function endMove() {
	    clearTimeout(this.timer);
    }

    function insertSliderCSS() {
        document.write(
            '<style>'+
            '#mmsliderpopup {'+
            '    font-family: sans-serif;'+
            '	width:'+this.width+'px; '+
            '	height:'+this.height+'px; '+
            '    border:1px solid #ddd;'+
            '	background:#eee;'+
            '	position:fixed;'+
            '	top:-1500px;'+
            '	left:-1500px;'+
            '    z-index: 999;'+
            '}'+
            '.mmsliderclose {'+
            '    float: right;'+
            '    cursor: pointer;'+
            '    width: 11px;'+
            '    height: 11px;'+
            '}'+
            '#mmsliderheader {'+
            '    font-size: 11px;'+
            '    background-color: #ddd;'+
            '}'+
            '#mmslidercontent {'+
            '    overflow: hidden;'+
            '}'+
            '</style>'
        );
    }

    function insertSliderHTML() {
        var header = '<div id="mmsliderheader">'+this.headline+'<img onclick="slider.hideEl(\'mmsliderpopup\');" class="mmsliderclose" src="http://ads.mmania.com/img/close2.gif" alt="close" /><div style="clear:both"></div></div>';
        var content = '<div id="mmslidercontent">'+this.content+'</div>';
        document.write('<div id="mmsliderpopup">'+header+content+'</div>');
    }

    function getWindowHeight() {
        var windowHeight = 0;
        if (typeof(window.innerHeight) == 'number') {
            windowHeight = window.innerHeight;
        } else {
            if (document.documentElement && document.documentElement.clientHeight) {
                windowHeight = document.documentElement.clientHeight;
            } else if (document.body && document.body.clientHeight) {
                windowHeight = document.body.clientHeight;
            }
        }
        return windowHeight;
    }

    function getCookie( cname ) {
        var search = cname + "=";
        var returnvalue = "";
        if( document.cookie.length > 0 ) {
            offset = document.cookie.indexOf( search );
            if( offset != -1 ) {
                offset += search.length;
                end = document.cookie.indexOf( ";", offset );
                if( end == -1 ) {
                    end = document.cookie.length;
                }
                returnvalue = unescape( document.cookie.substring(offset, end) );
            }
        }
        return returnvalue;
    }

    function isCapped( capping ) {
        var sessionSeconds;
        var sessionCount;
        if( capping instanceof Array ) {
            sessionCount = capping[0];
            sessionSeconds = capping[1];
        } else {
            sessionCount = 1;
            sessionSeconds = capping;
        }

        var sessionTime = sessionSeconds*1000;
        var cookiename = 'mmad_slider';
        var lastPopunder = getCookie(cookiename);
        var offset = lastPopunder.indexOf( ":" );
        var lastDisplayCount = parseInt(lastPopunder.substring( 0, offset ));
        var lastDisplayTime = parseInt(lastPopunder.substring( offset+1 ));

        var now = new Date().getTime();
        var counter = 1;
        if( isNaN(lastDisplayTime) || isNaN(lastDisplayCount) ) {
            // cookie not set yet => init
            document.cookie = cookiename+'=1:'+now;
            return false;
        } else if( now > (lastDisplayTime + sessionTime)) {
            // timelimit reached => reset
            document.cookie = cookiename+'=1:'+now;
            return false;
        } else if( lastDisplayCount < sessionCount ) {
            // capping counter not yet reached => increase counter
            lastDisplayCount++;
            document.cookie = cookiename+'='+lastDisplayCount+':'+now;
            return false;
        }
        return true;
    }

    function inTimerange( starthour, endhour ) {
        var now = new Date();
        var start = new Date();
        var end = new Date();
        start.setHours( starthour, 0, 0, 0 );
        end.setHours( endhour, 0, 0, 0 );

        if( end <= start ) {
            if( now >= start || now < end ) {
                return true;
            }
        } else {
            if( now >= start && now < end ) {
                return true;
            }
        }
        return false;
    }

    this.getCookie = getCookie;
    this.isCapped = isCapped;
    this.hideEl = hideEl;
    this.moveEl = moveEl;
    this.startMove = startMove;
    this.endMove = endMove;
    this.continueMove = continueMove;
    this.getWindowHeight = getWindowHeight;
    this.insertSliderHTML = insertSliderHTML;
    this.insertSliderCSS = insertSliderCSS;
}
