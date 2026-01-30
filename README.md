# bakery-accessibility-overturemap
SpatialData with BigQuery using Overturemap datasets
# The Smell of Bread: Paris vs. San Francisco
An urban accessibility study using **Overture Maps** and **BigQuery**.

## Project Goal
Comparing 300m walking access to bakeries/boulangeries between Paris (High Density) and San Francisco (Consolidated City-County).

## Tech Stack
* **Data:** Overture Maps (BigQuery Public Dataset)
* **Spatial Processing:** H3 Indexing (Resolution 10)
* **Visualization:** Kepler.gl
* **Functions:** BigQuery `ST_DWITHIN`, `ST_CENTROID`, and `jslibs.h3`.

## Methodology
We define "access" as any residential building footprint located within 300 meters of a 'bakery' or 'boulangerie' place category. Results are aggregated into H3 hexagons to visualize density.

## Data Attribution
This project uses data from the [Overture Maps Foundation](https://overturemaps.org). 

* **Dataset:** Overture Maps Places and Buildings layers.
* **License:** This work is made possible by the [Community Data License Agreement – Permissive, Version 2.0](https://cdla.dev/permissive-2-0/).

* Quick Start Guide
1. How to View the Map
-- I have exported the map configuration so you can view the interactive dual-city visualization without needing to write any code:
* Download the maps/bread_map.json file from this repository.
* Go to Kepler.gl/demo.
* Drag and drop the JSON file into the browser window.

## Technical notes

This analysis surfaced several non-obvious geospatial behaviors
(BigQuery regional UDFs, spatial scale effects, row-level EXISTS).

These are documented in detail in the Geo Analytics Playbook:
https://github.com/BlocklyS/geo-analytics-playbook


  
