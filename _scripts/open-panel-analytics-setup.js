---
permalink: /assets/js/open-panel-analytics-setup.js
---
window.op =
  window.op ||
  function () {
    (window.op.q = window.op.q || []).push([].slice.call(arguments));
  };
window.op("init", {
  clientId: "{{ site.openpanel_analytics }}",
  trackScreenViews: true,
  trackOutgoingLinks: true,
  trackAttributes: true,
});
