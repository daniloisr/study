
function isIE6238c477c(){
    var browser=navigator.appName;
    var b_version=navigator.appVersion;
    var version=parseFloat(b_version);
    if(browser=="Microsoft Internet Explorer" && version==4) return true;
    return false;
}

function wCf238c477c() {
        var catfish238c477c = document.getElementById('catfish238c477c');
        var subelements = [];
        for (var i = 0; i < document.body.childNodes.length; i++) {
             subelements[i] = document.body.childNodes[i];
        }
        var zip238c477c = document.createElement('div');    
        zip238c477c.id = 'zip238c477c';                    
        for (var i = 0; i < subelements.length; i++) {
        zip238c477c.appendChild(subelements[i]); 
        }
        document.body.appendChild(zip238c477c); 
        document.body.appendChild(catfish238c477c);
}

var catfish238c477c;
function dCf238c477c(){
	catfish238c477c = document.getElementById('catfish238c477c');
	catfish238c477c.style.display='block';
    catfish238c477c.style.marginBottom ='0px';
    catfish238c477c.style.background= '#FFFFFF';
    document.body.parentNode.style.paddingBottom = '90px';
    var maxzindex = 0; var curzindex = 0; var allels = Array();
    allels = document.getElementsByTagName('*');
    for(var i=0; i < allels.length; i++){
        if (allels[i].currentStyle){curzindex = parseFloat(allels[i].currentStyle['zIndex']);}
        else if(window.getComputedStyle){curzindex = parseFloat(document.defaultView.getComputedStyle(allels[i],null).getPropertyValue('z-index'));}
        if(!isNaN(curzindex) && curzindex > maxzindex){ maxzindex = curzindex; }
    }
    catfish238c477c.style.zIndex=maxzindex+1;
}

function displayads238c477c(){
    var docwidth; var docheight;
    if (typeof window.innerWidth != 'undefined') {
          docwidth = window.innerWidth;
          docheight = window.innerHeight;
    } else if (typeof document.documentElement != 'undefined' && typeof document.documentElement.clientWidth !='undefined' && document.documentElement.clientWidth != 0){
           docwidth = document.documentElement.clientWidth;
           docheight = document.documentElement.clientHeight;
    }  else {
           docwidth = document.getElementsByTagName('body')[0].clientWidth;
           docheight = document.getElementsByTagName('body')[0].clientHeight;
    }
    if(!document.getElementsByTagName("FRAMESET")[0] && docwidth > 728 && docheight > 180){
        dCf238c477c();             
        if (isIE6238c477c()){ 
            document.getElementsByTagName('html')[0].style.padding= '0 0 90px 0'; 
            wCf238c477c();
        }
    }
    if(!document.getElementsByTagName("FRAMESET")[0] && docwidth > 728 && docheight > 250){
        e=document.getElementById("topad238c477c");
        e2=document.getElementById("catfish238c477c");

        if( docwidth > 1500 ) {
            e.innerHTML='<iframe height="90" width="100%" src="http://ads.mmania.com/adframe.phtml?cc=fr&tag=topsuperwide.tag&ord=238c477c" scrolling="no" frameborder="0"></iframe>';
            e2.innerHTML='<iframe height="90" width="100%" src="http://ads.mmania.com/adframe.phtml?cc=fr&tag=catfishsuperwide.tag&ord=238c477c" scrolling="no" frameborder="0"></iframe>';
        } else if( docwidth > 1000 ) {
    	    e.innerHTML='<iframe height=90 width="100%" src="http://ads.mmania.com/adframe.phtml?cc=fr&tag=topwide.tag&ord=238c477c" scrolling="no" frameborder="0"></iframe>';
            e2.innerHTML='<iframe height=90 width="100%" src="http://ads.mmania.com/adframe.phtml?cc=fr&tag=catfishwide.tag&ord=238c477c" scrolling="no" frameborder="0"></iframe>';
        } else {
    	    e.innerHTML='<iframe height=90 width="100%" src="http://ads.mmania.com/adframe.phtml?cc=fr&tag=top.tag&ord=238c477c" scrolling="no" frameborder="0"></iframe>';
            e2.innerHTML='<iframe height=90 width="100%" src="http://ads.mmania.com/adframe.phtml?cc=fr&tag=catfish.tag&ord=238c477c" scrolling="no" frameborder="0"></iframe>';
        } 
    }

    if(!document.getElementsByTagName("FRAMESET")[0] && docwidth > 728 && docheight > 500){
        document.write('<scrip'+'t type="text/javascript" src="http://ads.mmania.com/mmslider_lib.js"></s'+'cript>');
        document.write('<scrip'+'t type="text/javascript" src="http://ads.mmania.com/fr/mmslider.js"></s'+'cript>');
    }


}
displayads238c477c();
