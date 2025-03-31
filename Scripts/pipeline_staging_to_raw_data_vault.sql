CREATE OR REPLACE TASK customer_strm_tsk
  WAREHOUSE = dv_rdv_wh
  SCHEDULE = '1 minute'
WHEN
  SYSTEM$STREAM_HAS_DATA('L00_STG.STG_CUSTOMER_STRM')
AS 
INSERT ALL
WHEN (SELECT COUNT(1) FROM hub_customer tgt WHERE tgt.sha1_hub_customer = src_sha1_hub_customer) = 0
THEN INTO hub_customer  
( sha1_hub_customer
, c_custkey
, ldts
, rscr
)  
VALUES 
( src_sha1_hub_customer
, src_c_custkey
, src_ldts
, src_rscr
)  
WHEN (SELECT COUNT(1) FROM sat_customer tgt WHERE tgt.sha1_hub_customer = src_sha1_hub_customer AND tgt.hash_diff = src_customer_hash_diff) = 0
THEN INTO sat_customer  
(
  sha1_hub_customer  
, ldts              
, c_name            
, c_address         
, c_phone           
, c_acctbal         
, c_mktsegment      
, c_comment         
, nationcode        
, hash_diff         
, rscr              
)  
VALUES 
(
  src_sha1_hub_customer  
, src_ldts              
, src_c_name            
, src_c_address         
, src_c_phone           
, src_c_acctbal         
, src_c_mktsegment      
, src_c_comment         
, src_nationcode        
, src_customer_hash_diff         
, src_rscr              
)
SELECT sha1_hub_customer   src_sha1_hub_customer
     , c_custkey           src_c_custkey
     , c_name              src_c_name
     , c_address           src_c_address
     , c_nationcode        src_nationcode
     , c_phone             src_c_phone
     , c_acctbal           src_c_acctbal
     , c_mktsegment        src_c_mktsegment
     , c_comment           src_c_comment    
     , customer_hash_diff  src_customer_hash_diff
     , ldts                src_ldts
     , rscr                src_rscr
  FROM l00_stg.stg_customer_strm_outbound src;

  


CREATE OR REPLACE TASK order_strm_tsk
  WAREHOUSE = dv_rdv_wh
  SCHEDULE = '1 minute'
WHEN
  SYSTEM$STREAM_HAS_DATA('L00_STG.STG_ORDERS_STRM')
AS 
INSERT ALL
WHEN (SELECT COUNT(1) FROM hub_order tgt WHERE tgt.sha1_hub_order = src_sha1_hub_order) = 0
THEN INTO hub_order  
( sha1_hub_order
, o_orderkey
, ldts
, rscr
)  
VALUES 
( src_sha1_hub_order
, src_o_orderkey
, src_ldts
, src_rscr
)  
WHEN (SELECT COUNT(1) FROM sat_order tgt WHERE tgt.sha1_hub_order = src_sha1_hub_order AND tgt.hash_diff = src_order_hash_diff) = 0
THEN INTO sat_order  
(
  sha1_hub_order  
, ldts              
, o_orderstatus  
, o_totalprice   
, o_orderdate    
, o_orderpriority
, o_clerk        
, o_shippriority 
, o_comment              
, hash_diff         
, rscr              
)  
VALUES 
(
  src_sha1_hub_order  
, src_ldts              
, src_o_orderstatus  
, src_o_totalprice   
, src_o_orderdate    
, src_o_orderpriority
, src_o_clerk        
, src_o_shippriority 
, src_o_comment      
, src_order_hash_diff         
, src_rscr              
)
WHEN (SELECT COUNT(1) FROM lnk_customer_order tgt WHERE tgt.sha1_lnk_customer_order = src_sha1_lnk_customer_order) = 0
THEN INTO lnk_customer_order  
(
  sha1_lnk_customer_order  
, sha1_hub_customer              
, sha1_hub_order  
, ldts
, rscr              
)  
VALUES 
(
  src_sha1_lnk_customer_order
, src_sha1_hub_customer
, src_sha1_hub_order  
, src_ldts              
, src_rscr              
)
SELECT sha1_hub_order          src_sha1_hub_order
     , sha1_lnk_customer_order src_sha1_lnk_customer_order
     , sha1_hub_customer       src_sha1_hub_customer
     , o_orderkey              src_o_orderkey
     , o_orderstatus           src_o_orderstatus  
     , o_totalprice            src_o_totalprice   
     , o_orderdate             src_o_orderdate    
     , o_orderpriority         src_o_orderpriority
     , o_clerk                 src_o_clerk        
     , o_shippriority          src_o_shippriority 
     , o_comment               src_o_comment      
     , order_hash_diff         src_order_hash_diff
     , ldts                    src_ldts
     , rscr                    src_rscr
  FROM l00_stg.stg_order_strm_outbound src;  
  

--start the tasks
ALTER TASK customer_strm_tsk RESUME;  
ALTER TASK order_strm_tsk    RESUME;  

--check the task history
SELECT *
  FROM table(information_schema.task_history())
  ORDER BY scheduled_time DESC;


--check data availability in tables
SELECT 'hub_customer', count(1) FROM hub_customer
UNION ALL
SELECT 'hub_order', count(1) FROM hub_order
UNION ALL
SELECT 'sat_customer', count(1) FROM sat_customer
UNION ALL
SELECT 'sat_order', count(1) FROM sat_order
UNION ALL
SELECT 'lnk_customer_order', count(1) FROM lnk_customer_order
UNION ALL
SELECT 'l00_stg.stg_customer_strm_outbound', count(1) FROM l00_stg.stg_customer_strm_outbound
UNION ALL
SELECT 'l00_stg.stg_order_strm_outbound', count(1) FROM l00_stg.stg_order_strm_outbound;