pfSense usefull scripts
========================================

![License: GPLv3](https://img.shields.io/github/license/binou-31/pfsense-scripts?style=flat-square)

## List of scripts

### installer_rst-sip-provider.sh

To make a suitable solution to reset states with an **external SIP Provider** after failback to primary gateway

Caution : It use Afterfilterchangeshellcmd feature and can broke your custom configuration if you already use it

* Inspired and to resolve issues referenced below
    * [SIP trunk failover/back on multi wan issues](https://forum.netgate.com/topic/58885/sip-trunk-failover-back-on-multi-wan-issues)
    * [Afterfilterchangeshellcmd](https://forum.netgate.com/topic/10704/afterfilterchangeshellcmd)
    * [Dual WAN SIP VoIP not failing over](https://forum.netgate.com/topic/110822/dual-wan-sip-voip-not-failing-over)
    * [SIP trunk multi wan state not flushed - issues - Solution?](https://forum.netgate.com/topic/66547/sip-trunk-multi-wan-state-not-flushed-issues-solution)

1. **How to install**

```shell
curl -s https://raw.githubusercontent.com/binou-31/pfsense-scripts/master/installer_rst-sip-provider.sh | sh -s $SIP_PROVIDER_URL
```

| Where SIP_PROVIDER_URL variable is your sip domain/IP *(e.g. : sip.provider.fr)*

2. **What does it do**
   * It create script `/usr/local/bin/rst-sip-provider.sh`
   * It install **ShellCMD** package to allow modification of the script launcher from the webGUI
   * It change the configuration _/conf/config.xml_ to work it

3. **To verify that it works**

```shell
# Execute
/etc/rc.filter_configure_sync

# You should seeing in the /var/log/system.log
clog -f /var/log/system.log
Apr 13 19:43:41 <hostname> /usr/local/bin/rst-sip-provider.sh[85545]: Reset States for SIP Provider (sip.provider.fr) killed 2 states from 1 sources and 1 destinations
```