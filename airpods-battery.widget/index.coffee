# Created by Daniel Taylor
# https://github.com/danieltaylor/airpods-battery-widget

# SETTINGS

COLOR = "white"
# "white" or "black"

ICON_STYLE = "solid"
# "line" or "solid"

ICON_LOCATION = "right"
# "left" or "right"

TEXT_SIZE = "20px"
ICON_SIZE = "18px"

MAC_ADDRESS = "00-00-00-00-00-00"
# Set this variable to the MAC address of your airpods to allow the widget to hide when airpods are not connected.
# The address can be found in one of two ways:
	# Option 1: While holding the option key, click on the bluetooth icon in the menu bar.  Mouse over your airpods in the devices list and the address will be displayed.
	# Option 2: Run "system_profiler SPBluetoothDataType" from the terminal and locate the address listed under your airpods.

SHOW_LAST_KNOWN_PERCENTAGES = false
# Set true to display the last known battery percentages even when airpods are disconnected.
# This will be overridden to true if a MAC address is not set.

SHOW_LAST_CASE_PERCENTAGE = true
# Even if airpods are connected, macOS will stop tracking the battery percentage of the case when not charging or open with airpods inside.  Set true to always display the last known case percentage (when available).

style: """
	position: absolute
	right: 10px
	bottom: 10px
	font-family: Roboto Thin
	text-align: right
	font-size: #{TEXT_SIZE}
	color: #{COLOR}
"""
# Set widget location, font family, etc.

refreshFrequency: 1000
# Set how often the widget refreshes.  Value is in ms.  Higher frequency = less CPU usage, but lower accuracy.


# NOTE: Settings to be modified are found above.  Anything below this line are inner workings of the widget and should not need to be modified, however, you are welcome to try if you so please.  For feature requests or bug reports, please submit an issue on the GitHub repository at https://github.com/danieltaylor/airpods-battery-widget

command: "./airpods-battery.widget/values.sh #{MAC_ADDRESS}"

render: (output)-> """
	<div id="airpods_widget">
		<link href="https://fonts.googleapis.com/css?family=Roboto&display=swap" rel="stylesheet">

		<span class="left_airpod_text left_of_icon"></span>
		<img width=#{ICON_SIZE}-2 src="./airpods-battery.widget/img/#{ICON_STYLE}/left-#{COLOR}.png">
		<span class="left_airpod_text right_of_icon"></span><br>

		<span class="right_airpod_text left_of_icon"></span>
		<img width=#{ICON_SIZE} src="./airpods-battery.widget/img/#{ICON_STYLE}/right-#{COLOR}.png">
		<span class="right_airpod_text right_of_icon"></span><br>

		<span class="case_text left_of_icon"></span>
		<img id=case_image width=#{ICON_SIZE} src="./airpods-battery.widget/img/#{ICON_STYLE}/case-#{COLOR}.png">
		<span class="case_text right_of_icon"></span><br id="case_br">
	</div>
"""

update: (output, domEl) ->
	left_percent = ' ' + output.split('\n')[0] + '%'
	right_percent = ' ' + output.split('\n')[1] + '%'
	case_percent =  ' ' + output.split('\n')[2] + '%'
	connected = output.split('\n')[3]

	if connected == '1' or MAC_ADDRESS == "00-00-00-00-00-00" or SHOW_LAST_KNOWN_PERCENTAGES
		$(domEl).find(".airpods_widget").show()
		$(domEl).find(".left_airpod_text").text("#{left_percent}")
		$(domEl).find(".right_airpod_text").text("#{right_percent}")

		if case_percent != " 0%"
			$(domEl).find(".case_text").text("#{case_percent}")
		else if $(domEl).find(".case_text").text() == "" or !SHOW_LAST_CASE_PERCENTAGE
			$(domEl).find(".case_text").hide()
			$(domEl).find("#case_image").hide()
			$(domEl).find("#case_br").hide()

		if ICON_LOCATION == "left"
			$(domEl).find(".left_of_icon").hide()
		else
			$(domEl).find(".right_of_icon").hide()
	else
		$(domEl).find(".airpods_widget").hide()
