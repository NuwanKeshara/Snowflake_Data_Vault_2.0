# Snowflake_Data_Vault_2.0

This project focused on redesign and implementation of scalable data warehouse solution utilizing the Data Vault 2.0 methodology within the Snowflake cloud data platform. By using the publicly available ‘snowflake_sample_data’ database, specifically the ‘tpch_sf10’ schema, this project demonstrated the practical application of Data Vault 2.0 principles to real world datasets. The project covered the Staging area, Raw Data Vault, Business Data Vault and Information Delivery stages, incorporating data sources such as the Customer, Orders, Region and Nation tables, which contain 1.5 million, 15 million, 5 and 25 records respectively. Furthermore the Information Delivery stage provided a dimensional data model using a star schema to
facilitate analytical querying for business intelligence and reporting.
![alt text](https://github.com/NuwanKeshara/Snowflake_Data_Vault_2.0/blob/main/cloud%20db.png?raw=true)

## - Following are the different layers and their architectural views.
![alt text](https://github.com/NuwanKeshara/Snowflake_Data_Vault_2.0/blob/main/Architecture%20Diagrams/Architecture-Staging%20Area.drawio.png?raw=true)
![alt text](https://github.com/NuwanKeshara/Snowflake_Data_Vault_2.0/blob/main/Architecture%20Diagrams/Architecture-Raw%20Data%20Vault.drawio.png?raw=true)
![alt text](https://github.com/NuwanKeshara/Snowflake_Data_Vault_2.0/blob/main/Architecture%20Diagrams/Architecture-Business%20Data%20Vault.drawio.png?raw=true)
![alt text](https://github.com/NuwanKeshara/Snowflake_Data_Vault_2.0/blob/main/Architecture%20Diagrams/Architecture-Information%20Delivery.drawio.png?raw=true)
