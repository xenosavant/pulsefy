function redirect(id) {
    var element = document.getElementById(id);
    var url = '/dialogue?id=' + element.id;
    window.location.replace(url);
}
