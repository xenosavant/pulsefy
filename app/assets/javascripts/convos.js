function redirect(id) {
    var element = document.getElementById(id);
    var url = '/conversation?id=' + element.id;
    window.location.replace(url);
}
