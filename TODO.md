IN ROUGH ORDER OF MORE IMPORTANT TO LEAST.


./scripts/hook.sh need to be n-ary instead of one package at time.
	
Hook Dirt Dependencies for install of parent package
	After drop in proot.
	But before the stage configure
	Need to run
	/scripts/hook.sh gconfmm-2.28.3
	After stage check_install
	/scripts/unhook-better.sh gconfmm-2.28.3

Hook Dirt Dependencies for parent package hook

Local download cache directory.
	After verify stage copy the stuff in there.
	Before fetch stage check there and skip download.
	For source control only packages that might get strange.

/scripts/unhook-better.sh to completely replace dirt command hook and ./scripts/unhook.sh

Rename list_dependencies_dirt to just dependencies_dirt
	??? Trying to seperate the viewing listing vs the installing.
	??? Not sure if this is better.

