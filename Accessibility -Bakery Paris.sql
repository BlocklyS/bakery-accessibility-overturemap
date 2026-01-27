--Data Source: Overture Maps Foundation, overturemaps.org.
WITH cities AS (
  SELECT names.primary AS city_name, country, geometry AS city_geom
  FROM `bigquery-public-data.overture_maps.division_area`
  WHERE 
    (names.primary = 'Paris' AND country = 'FR' AND subtype = 'locality')
    OR 
    (names.primary = 'San Francisco' AND country = 'US' AND subtype = 'county' AND class = 'land')
),

-- Paris Residential & Bakeries
eu_residential AS (
  SELECT
    b.id,
    ST_CENTROID(b.geometry) AS center,
    c.city_name,
    `jslibs.h3.ST_H3`(ST_CENTROID(b.geometry), 10) AS h3_id
  FROM `bigquery-public-data.overture_maps.building` b
  JOIN cities c ON c.country = 'FR' AND ST_INTERSECTS(b.geometry, c.city_geom)
  WHERE LOWER(b.subtype) = 'residential'
),
eu_bakeries AS (
  SELECT ST_CENTROID(p.geometry) AS center
  FROM `bigquery-public-data.overture_maps.place` p
  JOIN cities c ON c.country = 'FR' AND ST_INTERSECTS(p.geometry, c.city_geom)
  WHERE LOWER(p.categories.primary) IN ('bakery', 'boulangerie', 'cafe')
),

-- San Francisco Residential & Bakeries
us_residential AS (
  SELECT
    b.id,
    ST_CENTROID(b.geometry) AS center,
    c.city_name,
    `jslibs.h3.ST_H3`(ST_CENTROID(b.geometry), 10) AS h3_id
  FROM `bigquery-public-data.overture_maps.building` b
  JOIN cities c ON c.country = 'US' AND ST_INTERSECTS(b.geometry, c.city_geom)
  WHERE (LOWER(b.subtype) IN ('residential', 'house', 'apartments') OR b.subtype IS NULL)
),
us_bakeries AS (
  SELECT ST_CENTROID(p.geometry) AS center
  FROM `bigquery-public-data.overture_maps.place` p
  JOIN cities c ON c.country = 'US' AND ST_INTERSECTS(p.geometry, c.city_geom)
  WHERE LOWER(p.categories.primary) IN ('bakery', 'cafe')
),

-- Perform Proximity Check via Correlated Subqueries (Avoids Cartesian Joins)
combined_data AS (
  SELECT r.*, 
    EXISTS (SELECT 1 FROM eu_bakeries b WHERE ST_DWITHIN(r.center, b.center, 300)) AS has_access
  FROM eu_residential r
  UNION ALL
  SELECT r.*, 
    EXISTS (SELECT 1 FROM us_bakeries b WHERE ST_DWITHIN(r.center, b.center, 300)) AS has_access
  FROM us_residential r
)

-- Final Aggregation: Grouping ONLY by ID and City Name
SELECT
  city_name,
  h3_id,
  -- Efficiently retrieve the geometry without grouping by it
  `jslibs.h3.ST_H3_BOUNDARY`(h3_id) AS hex_geom, 
  COUNT(*) AS buildings_in_hex,
  COUNTIF(has_access) AS buildings_with_access,
  ROUND(100.0 * SAFE_DIVIDE(COUNTIF(has_access), COUNT(*)), 2) AS access_pct
FROM combined_data
GROUP BY city_name, h3_id 
ORDER BY city_name, access_pct DESC

LIMIT 20000;
