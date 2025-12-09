###  Business Process Modeling
### Objective: Model business process relevant to MIS.


###1. Overview

The Weather-Based Crop Advisory System automates the process of collecting daily weather data, analyzing it using crop requirements, and generating advisory messages for farmers.
The BPMN workflow consists of one pool and three lanes that represent the main actors and processes:

Weather Data Module

PL/SQL Processing Engine

Farmer

This ensures a smooth, automated flow from weather monitoring to crop advisory delivery.

### 2. Pool: Weather-Based Crop Advisory System

This pool represents the entire workflow from weather data ingestion to farmer action.

### Lane 1: Weather Data Module

This lane manages weather data acquisition and validation.

Main Activities

Collect Daily Weather Data
Gather temperature, rainfall, and humidity data from sensors or APIs.

Validate Weather Readings
Ensure accuracy and completeness of the collected weather data.

Store Weather Data
Insert validated data into the WEATHER_DATA table.

Trigger Advisory Generation
Notify the PL/SQL Engine that new weather data is available.

### Lane 2: PL/SQL Processing Engine

This lane handles the core advisory logic implemented in PL/SQL.

Main Activities

Start Advisory Generation Job
Automatically triggered when new weather data is inserted.

Retrieve Latest Weather (by location)
Get the most recent weather entry for each district/sector.

Fetch Crop Requirements
Retrieve ideal thresholds for temperature, rainfall, and humidity.

Loop Through Each Crop
Evaluate weather conditions for each crop type.

Call check_weather_status Function
Compare actual vs ideal conditions
→ Returns: GOOD, MODERATE, or BAD

Fetch Farmers in the Same Location
Identify farmers affected by current weather conditions.

Generate Advisory Message
Create a tailored recommendation based on the evaluation.

Insert Advisory Into ADVISORIES Table
Save the advisory for SMS/mobile delivery.

End Process

### Lane 3: Farmer

This lane represents how farmers interact with system advisories.

Main Activities

Receive Advisory Message
Via SMS or mobile application.

Read Recommended Action
Instructions like irrigation, delaying planting, or crop protection.

Take Farming Action
Apply the recommended farming steps.

### 3. Summary

The BPMN scenario provides a fully automated advisory pipeline:

Weather Monitoring

PL/SQL-based Analysis & Processing

Farmer Advisory Delivery

It enables timely, location-specific guidance that helps farmers protect crops, reduce risks, and improve agricultural productivity.




