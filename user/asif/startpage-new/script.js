function process() {
    var searchText = document.getElementById('search-bar-input-field').value;
    if (validateUrl(searchText)) {
        var url = !(searchText.includes('https://') || searchText.includes('ftp://') || searchText.includes('file://') || searchText.includes('http://')) ? 'https://' + searchText : searchText;
        window.location.replace(url);
    } else {
        var search_query_url = 'https://www.duckduckgo.com?q=' + searchText;
        window.location.replace(search_query_url);
    }
}

function validateUrl(url) {
    var regex = /^(http:\/\/www\.|https:\/\/www\.|http:\/\/|https:\/\/)?[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(\/.*)?$/;
    return regex.test(url);
}

window.onload = function() {
    console.log('hello!');
    document.getElementById('search-bar-input-field').addEventListener('keydown', function(event) {
        if (event.keyCode === 13) process();
    });
}
