USE [PBI_Reports]
GO

/****** Object:  StoredProcedure [dbo].[PBI_DORFiledByOwnerLevel_Live]    Script Date: 3/4/2024 8:25:04 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




/*  
-- =============================================          
 AUTHOR    :    Shayan Ul Haq 
 OBJECT NAME :  [PBI_DORFiledByOwnerLevel_Live]
 OBJECTTYPE  :  STORED PROCEDURE  
 CREATE DATE :  04th March, 2024  
 DESCRIPTION  : 
-- =============================================     
*/
CREATE PROCEDURE [dbo].[PBI_DORFiledByOwnerLevel_Live]
@OWNER_ID varchar(max) = NULL,    
@MRN nvarchar(200)= NULL,
@FROMDATE VARCHAR(25)='',    
@TODATE VARCHAR(25)= '',  
@CaseId  Bigint=NULL  ,
@adjnumber varchar(50)='',
@data_server varchar(3),
@IsInsert varchar(1) null --Y for data insertion data will be inserted into Table else only select.
AS
BEGIN
SET NOCOUNT ON;

BEGIN TRY

BEGIN TRAN;
IF OBJECT_ID('tempdb..#temp_dorfiled') IS NOT NULL
BEGIN
DROP TABLE #temp_dorfiled;
END

CREATE TABLE #temp_dorfiled
(
[MRN] nvarchar(200)	,
[Case ID] Bigint, 
[Patient Name]	nvarchar(100),
[Provider] nvarchar(100),	
[Case Type] nvarchar(100),	
[ADJ Number] nvarchar(50),
[GFS Billed] float,
[GFS Paid] money, 	
[GFS Outstanding] money, 	
[DOR Filed Date] datetime,
[data_server]varchar(6) null,
[owner_id] varchar(max) null
);
IF(@data_server IN ('ALL','KHI',''))
BEGIN
INSERT INTO #temp_dorfiled
(
[MRN] ,[Case ID] ,[Patient Name],[Provider], [Case Type] ,[ADJ Number]	,[GFS Billed] ,[GFS Paid] ,[GFS Outstanding] , 
[DOR Filed Date] ,[data_server],[owner_id] 

)

EXEC 
[EPM].[DBO].[PBI_DORFiledByOwnerLevel_Live]
@OWNER_ID  =@OWNER_ID, -- Owner ID for GFS    
@Fromdate =@FromDate,    
@Todate =@TODATE,
@linkSrv = '', 
@MRN = '', 
@Caseid = '',
@adjnumber ='';
update #temp_dorfiled SET data_server='KHI' where data_server=null
END

IF(@data_server IN ('ALL','IWP',''))
BEGIN
INSERT INTO #temp_dorfiled
(
[MRN] ,[Case ID] ,[Patient Name],[Provider], [Case Type] ,[ADJ Number]	,[GFS Billed] ,[GFS Paid] ,[GFS Outstanding] , 
[DOR Filed Date] ,[data_server],[owner_id] 

)

EXEC 
[EPM].[DBO].[PBI_DORFiledByOwnerLevel_Live]
@OWNER_ID  =@OWNER_ID, -- Owner ID for GFS    
@Fromdate =@FromDate,    
@Todate =@TODATE,
@linkSrv = '',
@adjnumber ='',
@MRN = '', 
@Caseid = '';
update #temp_dorfiled SET data_server='IWP' where data_server=null
END

IF(@data_server IN ('ALL','PI',''))
BEGIN
INSERT INTO #temp_dorfiled
(
[MRN] ,[Case ID] ,[Patient Name],[Provider], [Case Type] ,[ADJ Number]	,[GFS Billed] ,[GFS Paid] ,[GFS Outstanding] , 
[DOR Filed Date] ,[data_server],[owner_id] 

)

EXEC 
[EPM].[DBO].[PBI_DORFiledByOwnerLevel_Live]
@OWNER_ID  =@OWNER_ID, -- Owner ID for GFS    
@Fromdate =@FromDate,    
@Todate =@TODATE,
@linkSrv = '',
@adjnumber ='',
@MRN = '', 
@Caseid = '';
update #temp_dorfiled SET data_server='PI' where data_server=null
END

IF(@data_server IN ('ALL','PHY',''))
BEGIN
INSERT INTO #temp_dorfiled
(
[MRN] ,[Case ID] ,[Patient Name],[Provider], [Case Type] ,[ADJ Number]	,[GFS Billed] ,[GFS Paid] ,[GFS Outstanding] , 
[DOR Filed Date] ,[data_server],[owner_id] 

)

EXEC 
[EPM].[DBO].[PBI_DORFiledByOwnerLevel_Live]
@OWNER_ID  =@OWNER_ID, -- Owner ID for GFS    
@Fromdate =@FromDate,    
@Todate =@TODATE,
@linkSrv = '', 
@MRN = '', 
@adjnumber ='',
@Caseid = '';
update #temp_dorfiled SET data_server='PHY' where data_server=null
END
IF(@IsInsert='Y')
BEGIN
Insert into DORFiledByOwnerLevel_Live
(
[MRN] ,[Case ID] ,[Patient Name],[Provider], [Case Type] ,[ADJ Number]	,[GFS Billed] ,[GFS Paid] ,[GFS Outstanding] , 
[DOR Filed Date] ,[data_server],[owner_id] 

)

select
(
[MRN] , [Case ID] ,[Patient Name],[Provider], [Case Type] ,[ADJ Number]	,[GFS Billed] ,[GFS Paid] ,[GFS Outstanding] , 
[DOR Filed Date] ,[data_server],[owner_id] 


from #temp_dorfiled

END
COMMIT;

IF(@IsInsert<>'Y')
BEGIN
SELECT * from #temp_dorfiled
END


END TRY
BEGIN CATCH
print ERROR_MESSAGE();
IF(@@TRANCOUNT>0)
BEGIN
ROLLBACK;
END

END CATCH


END
GO