/* 
 View contains logic for calculating the correct relationship between application and co_customer.
 View only contain relationships where the application is active status is true and co_in is true.
 */
CREATE OR REPLACE VIEW DV.CO_CUSTOMER_APPLICATION_L 
AS 

SELECT 
	co_customer_application_key
	,customer_key
	,application_key
	,load_dts
	,rec_src
FROM (
	  SELECT 
			customer_key||'|'||application_key AS co_customer_application_key
			,load_dts
			,customer_key
			,application_key
			,rec_src
			,row_number() over(
				PARTITION BY customer_key, application_key ORDER BY eff_ts DESC 
				) rnk
		   FROM (		
				  SELECT
						social_security_number AS customer_key
						,id -1 AS application_key
						,_SDC_RECEIVED_AT AS load_dts
						,'edge' AS rec_src
						,created AS eff_ts
					FROM 
						src_edge.CUSTOMER 
					WHERE is_co = true
					AND active <> FALSE
			)q
)res
WHERE res.rnk = 1
;