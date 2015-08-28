(function() {
  var queryInfo = {
    currentWindow: true
  };

  document.addEventListener('DOMContentLoaded', function() {
    var div = document.querySelector('#container');
    var elm = Elm.embed(Elm.Popup, div, { tabs: [] });

    chrome.tabs.query(queryInfo, function(tabs) {
      elm.ports.tabs.send(tabs);
    });
  });
})();
