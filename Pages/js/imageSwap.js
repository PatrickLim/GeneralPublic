var imagesSwap = [];

imagesSwap[0] = ["images/banner/image-name.jpg"];


var imgLength = imagesSwap.length;

//var i = Math.floor((imgLength)*Math.random());
var i = 0;


function bgChange() {
    var myTimer = backgroundChange.delay(5000);
}



function backgroundChange() {
    var m = $('fadeImg');
    var fx = new Fx.Tween(m, {

        duration: 1000,
        onComplete: function() {
            m.src = "";
            m.src = imagesSwap[i];
            var myTimer2 = backgroundChange2.delay(100);
        }
    });
    fx.start('opacity', 1, 0);
}

function backgroundChange2() {
    var m = $('fadeImg');
    var fx2 = new Fx.Tween(m, {
        duration: 1000,
        onComplete: function() {
            i++
            if (i >= imgLength) {
                i = 0;
            }
            bgChange();
        }

    });
    fx2.start('opacity', 0, 1);
}

window.addEvent('domready', function() {

    var imgdiv = document.createElement('div');
    imgdiv.setAttribute('id', 'imgFadePreload');
    imgdiv.style.display = 'none';

    var swapLength = imagesSwap.length;
    for (var j = 0; j < swapLength; j++) {
        imgdiv.innerHTML += '<img src="' + imagesSwap[j] + '" />';
    }
    document.body.appendChild(imgdiv);
    $('fadeImg').src = imagesSwap[i];
    i++;
    if (i >= imgLength) {
        i = 0;
    }
    var mTime = bgChange.delay(5000);
});

