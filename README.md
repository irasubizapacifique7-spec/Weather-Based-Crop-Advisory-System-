# Weather-Based-Crop-Advisory-System-
The Weather-Based Crop Advisory System is a PL/SQL-driven application that analyzes daily weather data against ideal crop requirements to provide Rwandan farmers with automated, data-driven advisories on planting, irrigation, and harvesting.


#  Weather-Based Crop Advisory System for Agricultural Decision Support in Rwanda

## Project Overview

This project is a comprehensive capstone developed for the course **Database Development with PL/SQL (INSY 8311)** at the **Adventist University of Central Africa (AUCA)**.

Agriculture remains one of the most important sectors in Rwanda, yet it is heavily influenced by unpredictable weather conditions. This system provides **data-driven, automated crop advisories** by comparing real-time weather records with crop-specific requirements.  
All business rules are implemented using **Oracle PL/SQL**, making the solution reliable, efficient, and fully database-driven.

---

##  Project Details

| Detail | Value |
|-------|-------|
| **Project Title** | Weather-Based Crop Advisory System for Agricultural Decision Support in Rwanda |
| **Student Name** | Irasubiza Pacifique |
| **Student ID** | 27983 |
| **Core Technology** | Oracle Database, PL/SQL |
| **Objective** | Generate automated crop advisories (**GOOD**, **MODERATE**, **BAD**) by comparing weather data with ideal crop requirements |

---

##  Key Features

###  Automated Advisory Generation  
A main PL/SQL procedure **`GENERATE_ADVISORY`** reads weather data, compares it with each crop’s requirements, and generates advisory messages automatically.

###  Weather Status Classification  
A PL/SQL function **`CHECK_WEATHER_STATUS`** determines whether weather conditions are **GOOD**, **MODERATE**, or **BAD** for a crop based on:
- Temperature  
- Rainfall  
- Humidity  

###  Smart Decision Support  
Advisories help farmers make informed choices regarding:
- Planting time  
- Irrigation needs  
- Disease and pest risk management  

###  Fully Data-Driven  
All decisions are generated based on factual data stored within the database, reducing guesswork and enhancing agricultural productivity.

---

##  Database Schema (Core Entities)

The system is built around **five main tables**, each serving a critical role:

| Table Name | Purpose | Primary Key | Key Foreign Keys |
|-----------|----------|-------------|------------------|
| **FARMERS** | Stores farmer information (contacts, location). | `farmer_id` | — |
| **CROPS** | Stores types of crops and seasons. | `crop_id` | — |
| **WEATHER_DATA** | Stores daily weather readings per location. | `weather_id` | — |
| **CROP_REQUIREMENTS** | Stores ideal weather ranges for each crop. | `req_id` | `crop_id` |
| **ADVISORIES** | Stores historical advisory messages. | `advisory_id` | `farmer_id`, `crop_id`, `weather_id` |

---

##  Technical Implementation (PL/SQL Logic)

###  Function: `CHECK_WEATHER_STATUS`

**Purpose:**  
Evaluates weather data by comparing actual values with the ideal crop requirements stored in `CROP_REQUIREMENTS`.

**Returns:**  
- `GOOD`  
- `MODERATE`  
- `BAD`  

---

###  Procedure: `GENERATE_ADVISORY`

**Purpose:**  
Generates advisories 


 Conclusion

The **Weather-Based Crop Advisory System** is a robust, scalable, and fully automated PL/SQL-driven solution designed to support Rwandan farmers with accurate, real-time agricultural guidance.

By integrating:
- Real weather data  
- Crop-specific requirements  
- Automated advisory logic  
- Security and auditing mechanisms  

…the system delivers reliable decision support that can significantly improve agricultural productivity.  
This solution contributes to **sustainable, efficient, and climate-smart farming practices in Rwanda**, aligning with national goals for modern agriculture.

---
