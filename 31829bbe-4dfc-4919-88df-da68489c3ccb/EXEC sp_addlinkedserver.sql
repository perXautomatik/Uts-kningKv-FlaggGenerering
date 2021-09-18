
USE master;
GO
EXEC sp_addlinkedserver
GO


<data-source source="LOCAL" name="EDPRemote" group="External" uuid="8cc23256-e02c-43ea-8477-e740c4580b62">
    <database-info product="Microsoft SQL Server"
    version="12.00.5223"
    jdbc-version="4.2"
    driver-name="Microsoft JDBC Driver 7.2 for SQL Server"
    driver-version="7.2.1.0"
    dbms="MSSQL"
    exact-version="12.0.5223"
    exact-driver-version="7.2">
    <extra-name-characters>$#@</extra-name-characters>
    <identifier-quote-string>&quot;</identifier-quote-string>
</database-info><case-sensitivity plain-identifiers="mixed" quoted-identifiers="mixed"/><driver-ref>sqlserver.ms</driver-ref><synchronize>true</synchronize><jdbc-driver>com.microsoft.sqlserver.jdbc.SQLServerDriver</jdbc-driver><jdbc-url>jdbc:sqlserver://admsql04</jdbc-url><secret-storage>master_key</secret-storage><domain-auth>true</domain-auth><schema-mapping><introspection-scope><node negative="1"><node kind="database"><name qname="EDPGeodata"/><name qname="EDPVisionRegionGotland"/><name qname="EDPVisionRegionGotlandAvlopp"/><name qname="EDPVisionRegionGotlandTest"/><node kind="schema" qname="dbo"/></node><node kind="database"><name qname="EDPVisionRegionGotlandAvloppFiler"/><name qname="EDPVisionRegionGotlandFiler1"/><node kind="schema" negative="1"/></node><node kind="database"><name qname="EDPVisionRegionGotlandFiler"/><name qname="EDPVisionRegionGotlandFilerSolen"/><node kind="schema" qname="@"/></node></node></introspection-scope></schema-mapping></data-source>
#END#