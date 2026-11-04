. /lib/functions/system.sh

preinit_set_mac_address() {
	case $(board_name) in
	acer,predator-w6|\
	acer,predator-w6d)
		$(mmc_get_mac_ascii u-boot-env WANMAC)
		$(mmc_get_mac_ascii u-boot-env LANMAC)
		ip link set dev lan1 address "$lan_mac"
		ip link set dev lan2 address "$lan_mac"
		ip link set dev lan3 address "$lan_mac"
		ip link set dev game address "$lan_mac"
		ip link set dev eth1 address "$wan_mac"
		;;
	acer,predator-w6x-stock|\
	acer,predator-w6x-ubootmod)
		wan_mac=$(mtd_get_mac_ascii u-boot-env ethaddr)
		lan_mac=$(macaddr_add "$wan_mac" 1)
		ip link set dev lan1 address "$lan_mac"
		ip link set dev lan2 address "$lan_mac"
		ip link set dev lan3 address "$lan_mac"
		ip link set dev lan4 address "$lan_mac"
		ip link set dev eth1 address "$wan_mac"
		;;
	acer,vero-w6m)
		wan_mac=$(mmc_get_mac_ascii u-boot-env WANMAC)
		lan_mac=$(mmc_get_mac_ascii u-boot-env LANMAC)
		ip link set dev lan1 address "$lan_mac"
		ip link set dev lan2 address "$lan_mac"
		ip link set dev lan3 address "$lan_mac"
		ip link set dev internet address "$wan_mac"
		;;
	asus,tuf-ax4200|\
	asus,tuf-ax4200q|\
	asus,tuf-ax6000)
		CI_UBIPART="UBI_DEV"
		addr=$(mtd_get_mac_binary_ubi "Factory" 0x4)
		ip link set dev eth0 address "$addr"
		ip link set dev eth1 address "$addr"
		;;
	cetron,ct3003|\
	cetron,ct3003-112m|\
	cetron,ct3003-ubootmod)
		lan_mac=$(mtd_get_mac_ascii art MAC_ADDRESS)
		[ -z "$lan_mac" ] && lan_mac=$(mtd_get_mac_ascii art mac)
		[ -z "$lan_mac" ] && lan_mac=$(mtd_get_mac_ascii u-boot-env ethaddr)
		[ -z "$lan_mac" ] && lan_mac=$(mtd_get_mac_ascii u-boot-env mac)
		[ -z "$lan_mac" ] && lan_mac=$(mtd_get_mac_binary Factory 0x4)
		wan_mac=$(macaddr_add "$lan_mac" 3)
		[ -n "$lan_mac" ] && {
			ip link set dev eth0 address "$lan_mac" 2>/dev/null
			ip link set dev lan1 address "$lan_mac" 2>/dev/null
			ip link set dev lan2 address "$lan_mac" 2>/dev/null
			ip link set dev lan3 address "$lan_mac" 2>/dev/null
		}
		[ -n "$wan_mac" ] && ip link set dev wan address "$wan_mac" 2>/dev/null
		;;
	mercusys,mr90x-v1|\
	tplink,archer-ax80-v1|\
	tplink,archer-ax80-v1-eu|\
	tplink,re6000xd)
		addr=$(get_mac_binary "/tmp/tp_data/default-mac" 0)
		ip link set dev eth1 address "$(macaddr_add $addr 1)"
		;;
	tplink,be450)
		addr=$(get_mac_binary "/tmp/tp_data/default-mac" 0)
		ip link set dev eth1 address "$(macaddr_add $addr 1)"
		ip link set dev eth2 address "$(macaddr_add $addr 2)"
		;;
	tplink,fr365-v1)
		lan_mac=$(strings /dev/mtd11 | grep 'option macaddr' | awk -F"'" '{print $2}')
		wan_mac="$(macaddr_add $lan_mac 1)"
		ip link set dev port2 address "$wan_mac"
		ip link set dev port1 address "$lan_mac"
		ip link set dev port3 address "$lan_mac"
		ip link set dev port4 address "$lan_mac"
		ip link set dev port5 address "$lan_mac"
		ip link set dev port6 address "$lan_mac"
		;;
	*)
		;;
	esac
}

boot_hook_add preinit_main preinit_set_mac_address
