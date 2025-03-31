USE SCHEMA l30_id;

-- DIM TYPE Customer
CREATE OR REPLACE VIEW dim_customer 
AS 
SELECT hub.sha1_hub_customer                      AS customer_surrogate_key
     , sat.ldts                                   AS effective_dts
     , hub.c_custkey                              AS customer_id
     , sat.rscr                                   AS record_source
     , sat.*     
  FROM l10_rdv.hub_customer                       hub
     , l20_bdv.sat_customer_bv_curr_vw            sat
 WHERE hub.sha1_hub_customer                      = sat.sha1_hub_customer;

 
-- DIM TYPE Order
CREATE OR REPLACE VIEW dim_order
AS 
SELECT hub.sha1_hub_order                         AS order_surrogate_key
     , sat.ldts                                   AS effective_dts
     , hub.o_orderkey                             AS order_id
     , sat.rscr                                   AS record_source
     , sat.*
  FROM l10_rdv.hub_order                          hub
     , l20_bdv.sat_order_bv_curr_vw               sat
 WHERE hub.sha1_hub_order                         = sat.sha1_hub_order;

 
-- FACT table
CREATE OR REPLACE VIEW fct_customer_order
AS
SELECT lnk.ldts                                   AS effective_dts     
     , lnk.rscr                                   AS record_source
     , lnk.sha1_hub_customer                      AS customer_surrogate_key
     , lnk.sha1_hub_order                         AS order_surrogate_key
  FROM l10_rdv.lnk_customer_order                 lnk;  



--check the new row count
USE SCHEMA l30_id;

SELECT COUNT(1) FROM dim_customer;


--data visualize from Snowsight
SELECT dc.nation_name
     , dc.region_name
     , do.order_priority_bucket
     , COUNT(1)                                   cnt_orders
  FROM fct_customer_order                         fct
     , dim_customer                              dc
     , dim_order                                 do
 WHERE fct.customer_surrogate_key                       = dc.customer_surrogate_key
   AND fct.order_surrogate_key                          = do.order_surrogate_key
GROUP BY 1,2,3;
