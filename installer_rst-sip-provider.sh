#!/bin/sh
##
## Installer of the flush script SIP provider
##
## Copyleft : Fabien RIVIERE

[ -z "$1" ] && echo "Usage : $0 [SIP_PROVIDER_URL]" && exit 0
SIPPROVIDER=$1

shellCMDConfig="""        <config>\
                            <cmd>/usr/local/bin/rst-sip-provider.sh ${SIPPROVIDER}</cmd>\
                            <cmdtype>afterfilterchangeshellcmd</cmdtype>\
                            <description><![CDATA[Script reset states SIP PROVIDER]]></description>\
                        </config>\
                </shellcmdsettings>"""

systemCMDConfig="""        \<afterfilterchangeshellcmd>/usr/local/bin/rst-sip-provider.sh ${SIPPROVIDER}</afterfilterchangeshellcmd>\
        </system>"""

# ShellCMD Installation for the WebUI
pkg install -qy pfSense-pkg-Shellcmd

# Script creation
cat > /usr/local/bin/rst-sip-provider.sh <<'EOF'
#!/bin/sh
##
## Reset States for SIP Provider
##
[ -z "$1" ] && echo "Usage : $0 [SIP_PROVIDER_URL]" && exit 0
SIPPROVIDER=$1
(echo -n "Reset States for SIP Provider (${SIPPROVIDER}) ";/sbin/pfctl -k 0.0.0.0/0 -k ${SIPPROVIDER} 2>&1) | /usr/bin/logger -p daemon.info -i -t $0
EOF
# Permissions
chmod 755 /usr/local/bin/rst-sip-provider.sh

# Replace configuration
sed -ie "s|</shellcmdsettings>|$shellCMDConfig|" /conf/config.xml
sed -ie "s|</system>|$systemCMDConfig|" /conf/config.xml

# Load new configuration
rm -f /tmp/config.cache
# First execution after filters are sync
/etc/rc.filter_configure_sync

