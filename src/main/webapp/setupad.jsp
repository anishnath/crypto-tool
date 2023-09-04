<!-- INSERT IN <head> ------------------------------------------------------------------------------------------ -->

<!--    Start of scripts for lazy loading-->
<script src="https://cdn.jsdelivr.net/npm/in-view@0.6.1/dist/in-view.min.js"></script>
<script>inView.offset(-200);</script>
<!--    End of scripts for lazy loading-->

<script async src="https://securepubads.g.doubleclick.net/tag/js/gpt.js"></script>
<script>
    stpd = window.stpd || {que: []};
    window.googletag = window.googletag || {cmd: []};
    googletag.cmd.push(function() {
        if (window.innerWidth >= 1200) {
            googletag.defineSlot('/147246189,22976055811/8gwifi.org_336x336_sidebar_desktop', [[336,336],[336,320],[320,336],[320,320],[300,300],[336,280],[320,250],[300,250]], 'site_8gwifi_org_sidebar_desktop').addService(googletag.pubads());            
        } else if (window.innerWidth >= 992) {
            googletag.defineSlot('/147246189,22976055811/8gwifi.org_250x250_sidebar_desktop', [[250,250]], 'site_8gwifi_org_sidebar_desktop').addService(googletag.pubads());            
        }

        if (window.innerWidth >= 1490) {
            googletag.defineSlot('/147246189,22976055811/8gwifi.org_160x600_siderail_left_desktop', [[160,600],[120,600]], 'site_8gwifi_org_siderail_left_desktop').addService(googletag.pubads());            
            googletag.defineSlot('/147246189,22976055811/8gwifi.org_160x600_siderail_right_desktop', [[160,600],[120,600]], 'site_8gwifi_org_siderail_right_desktop').addService(googletag.pubads());            
        }

        if (window.innerWidth >= 1000) {
            googletag.defineSlot('/147246189,22976055811/8gwifi.org_1000x100_anchor_desktop', [[1000,100],[970,90],[728,90],[990,90],[970,50],[960,90],[950,90],[980,90]], 'site_8gwifi_org_anchor_responsive').addService(googletag.pubads());            
        } else {
            googletag.defineSlot('/147246189,22976055811/8gwifi.org_320x100_anchor_mobile', [[320,100],[320,50],[300,100],[300,50]], 'site_8gwifi_org_anchor_responsive').addService(googletag.pubads());            
        }    
                        
        var interstitialSlot = googletag.defineOutOfPageSlot('/147246189,22976055811/8gwifi.org_interstitial', googletag.enums.OutOfPageFormat.INTERSTITIAL);
        if (interstitialSlot) interstitialSlot.addService(googletag.pubads());

        googletag.pubads().disableInitialLoad();
        googletag.pubads().enableSingleRequest();
        googletag.pubads().collapseEmptyDivs();
        googletag.enableServices();
        googletag.display(interstitialSlot);
    });    
</script>
<script async src="https://stpd.cloud/saas/5796"></script>
<style>
    @media (min-width: 1000px) {
        #site_8gwifi_org_leaderboard_responsive {
            min-height: 336px !important;
        }
    }
</style>