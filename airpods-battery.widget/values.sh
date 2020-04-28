defaults read /Library/Preferences/com.apple.Bluetooth | grep BatteryPercentLeft | tr -d \; | awk '{print $3}'
defaults read /Library/Preferences/com.apple.Bluetooth | grep BatteryPercentRight | tr -d \; | awk '{print $3}'
defaults read /Library/Preferences/com.apple.Bluetooth | grep BatteryPercentCase | tr -d \; | awk '{print $3}'
grep -ia6 "$1" <(system_profiler SPBluetoothDataType 2>/dev/null) | awk '/Connected: Yes/{print 1}'
