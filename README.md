# Car Milage and Maintenance Tracker 

Sample Application Developed in Flutter for Mobile Devices

Keeps Records of Car's Gas Consumption and Maintenance. 

### Gas Records 
* User Enters: 
  * Date
  * Current Milage
  * Gallons Filled
  * Price per Gallon
* Data Recorded: 
  * Day(s) since Last Fill Up
  * Total Miles Driven since List Fill Up
  * Average MPG for Trips
  * Changes in Gallons consumed since Last Fill Up 
  * Changes in Price per Gallon since Last Fill Up

### Maintenance Records 
* User Enters: 
  * Date
  * Current Milage
  * Able to Append Sub-Record(s) Containing:
    * General Summary of Work Done
    * Price of Individual Maintenance
    * Any Extra Notes

## Sample Images 
Home Screen | New Gas Record | Preivew Gas Records | New Record | Expand New Record
------------ | ------------- | ------------- | ------------- | -------------
<img src="https://github.com/KevinMalm/gasMilageTracker_FLUTTER/blob/framework_build_out/Sample%20Screenshots/main_screen.png" alt="main_plash" width="175" height="330"> | <img src="https://github.com/KevinMalm/gasMilageTracker_FLUTTER/blob/framework_build_out/Sample%20Screenshots/New%20Gas%20Record.png" alt="main_plash" width="175" height="330">  | <img src="https://github.com/KevinMalm/gasMilageTracker_FLUTTER/blob/framework_build_out/Sample%20Screenshots/Gallons%20Tracker.png" alt="main_plash" width="175" height="330"> | <img src="https://github.com/KevinMalm/gasMilageTracker_FLUTTER/blob/framework_build_out/Sample%20Screenshots/View%20All%20Records.png" alt="main_plash" width="175" height="330"> | <img src="https://github.com/KevinMalm/gasMilageTracker_FLUTTER/blob/framework_build_out/Sample%20Screenshots/View%20All%20Records_Expanded.png" width="175" height="330"> 


## Following Next Steps

<strong> Gas Records Graphs </strong><br>
Currently not very pleased with the Graph Library currently being used. As of now, the data is graphed with a X axis step of 7 Days and the current library can not easly handle plotting individual recorods on the Graph. Possible fix would be plotting the X axis as the unique ID of the Gas Record and adding a Text Widget below to handle displaying the current date. Likewise, the current Graph Library can not handle plotting multiple Graphs on top of each other with different Y Axis's. 
<br><br><strong> Saving Data </strong><br>
Each Time a new Record is Added or Changed, call to the Data Manager class will need to save the data locally to the device. 
<br>--<br>
With this, easily deleting records will need to be added. 
