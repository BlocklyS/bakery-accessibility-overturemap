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

  
