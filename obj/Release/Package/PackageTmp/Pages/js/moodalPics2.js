
var imageidx = 0;
var sample = [];
var thesePics = [];

loadImages();

function loadImages() {

    sample[0] = ["folder/imagename.jpg", "720", "360"];


}



function swapNext() {
    var links;
    image = thesePics[++imageidx];
    var imagesLength = thesePics.length - 1;
    if (imageidx >= imagesLength) {
        links = '<a href="javascript:swapPrev();">Previous</a>'
    }
    else {
        links = '<a href="javascript:swapPrev();">Previous</a>&nbsp;<a href="javascript:swapNext();">Next</a>'

    }

    MOOdalBox.open('loadimg.php?img=' + image[0], links, image[1] + ' ' + image[2])

}

function swapPrev() {
    var links;
    image = thesePics[--imageidx];
    if (imageidx <= 0) {
        links = '<a href="javascript:swapNext();">Next</a>'
    }
    else {
        links = '<a href="javascript:swapPrev();">Previous</a>&nbsp;&nbsp;<a href="javascript:swapNext();">Next</a>'

    }

    MOOdalBox.open('loadimg.php?img=' + image[0], links, image[1] + ' ' + image[2])
}

function start(whatPics) {
    imageidx = 0;
    if (whatPics) {
        var image = whatPics[0];
        thesePics = whatPics;
    }
    else {
        var image = images[0];
        whatPics = images;
        thesePics = whatPics;
    }
    MOOdalBox.open('loadimg.php?img=' + image[0], '<a href="javascript:swapNext();">Next</a>', image[1] + ' ' + image[2])
}