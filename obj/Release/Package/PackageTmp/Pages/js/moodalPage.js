
var pageidx = 0;
var sample = [];
var pages = [];
var thesePages = [];
loadPages();

function loadPages() {

    sample[0] = ["page-name.php", "900", "507"];
}

function swapNextPage() {
    var pagelinks;
    page = thesePages[++pageidx];
    var pagesLength = thesePages.length - 1;
    if (pageidx >= pagesLength) {
        pagelinks = '<a href="javascript:swapPrevPage();">Previous</a>'
    }
    else {
        pagelinks = '<a href="javascript:swapPrevPage();">Previous</a>&nbsp;<a href="javascript:swapNextPage();">Next</a>'

    }
    MOOdalBox.open(page[0], pagelinks, page[1] + ' ' + page[2])

}

function swapPrevPage() {
    var pagelinks;
    page = thesePages[--pageidx];
    if (pageidx <= 0) {
        pagelinks = '<a href="javascript:swapNextPage();">Next</a>'
    }
    else {
        pagelinks = '<a href="javascript:swapPrevPage();">Previous</a>&nbsp;&nbsp;<a href="javascript:swapNextPage();">Next</a>'

    }
    MOOdalBox.open(page[0], pagelinks, page[1] + ' ' + page[2])
}

function startPages(whatPages, indx) {
    pageidx = indx;
    if (whatPages) {
        var page = whatPages[pageidx];
        thesePages = whatPages;
    }
    else {
        var page = pages[pageidx];
        whatPages = pages;
        thesePages = whatPages;
    }
    if (pageidx == '0') {
        MOOdalBox.open(page[0], '<a href="javascript:swapNextPage();">Next</a>', page[1] + ' ' + page[2])
    }
    else if (pageidx == thesePages.length - 1) {
        MOOdalBox.open(page[0], '<a href="javascript:swapPrevPage();">Previous</a>', page[1] + ' ' + page[2])
    }
    else {
        MOOdalBox.open(page[0], '<a href="javascript:swapPrevPage();">Previous</a>&nbsp;&nbsp;<a href="javascript:swapNextPage();">Next</a>', page[1] + ' ' + page[2])
    }
}