function redirect(id) {
    var element = document.getElementById(id);
    var url = '/convo?id=' + element.id;
    window.location.replace(url);
}
