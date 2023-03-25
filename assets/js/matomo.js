var _paq = window._paq = window._paq || [];
_paq.push(['trackPageView']);
_paq.push(['enableLinkTracking']);
(function () {
    var matomoUrl = "${MATOMO_URL}";
    var siteId = "${MATOMO_SITE_ID}";
    if (matomoUrl && siteId) {
        _paq.push(['setTrackerUrl', matomoUrl + 'matomo.php']);
        _paq.push(['setSiteId', siteId]);
        var d = document,
            g = d.createElement('script'),
            s = d.getElementsByTagName('script')[0];
        g.async = true;
        g.src = matomoUrl + 'matomo.js';
        s.parentNode.insertBefore(g, s);
    }
})();
