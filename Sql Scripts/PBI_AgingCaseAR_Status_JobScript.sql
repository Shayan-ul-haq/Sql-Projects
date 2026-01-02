/*
-- =============================================                                                                          

 AUTHOR    :    SHAYAN UL HAQ
 OBJECT NAME :  [PBI_AgingCaseAR_Status_JobScript] 
 OBJECTTYPE  :  STORED PROCEDURE                                                                  
 CREATE DATE :  18th MARCH, 2024
 DESCRIPTION  : This can be scheduled on any time interval

 N O T E:		THIS WILL GET KHI DATA TO POPULATE TO KARACHI POWER PBI
-- =============================================                                                                     

*/

CREATE PROCEDURE [dbo].[PBI_AgingCaseAR_Status_JobScript]                                                  

AS
BEGIN
SET NOCOUNT ON;
--SET XACT_ABORT ON ;
------------------------------------------------------------------------------------------------------------
-- INSERTion on Power BI Server Karachi will be done here after comparing ID count of both the
-- tables via linked server 
-- if target ID is less then the source ID then INSERT process will start
------------------------------------------------------------------------------------------------------------
declare @fromdate datetime, @todate datetime;
declare @Vfromdate date, @Vtodate date;
declare @IDSource bigint, @IDTarget bigint;
declare @SourceCount bigint, @TargetCount bigint, @CNT BIGINT;
declare @RowsProcessed bigint, @ProcessStartedOn datetime;
Set @ProcessStartedOn = getdate();

SELECT @fromdate=max(ID) FROM [PBI_Reports].[dbo].[AgingCaseAR_Status] where data_server='KHI';
SET @Vfromdate = convert(varchar, @fromdate, 25);
--select @fromdate = FORMAT(@fromdate, 'yyyy-MM-dd hh:mm tt');
select @todate = FORMAT(getdate(), 'yyyy-MM-dd hh:mm tt');
SET @Vtodate = convert(varchar,GETDATE(), 25);
select 'Form Date: ', @fromdate, ' To Date: ', @todate;

--BEGIN DISTRIBUTED TRANSACTION
BEGIN TRY
 -- succeeds

IF OBJECT_ID('tempdb..#TEMP_KHI_AgingCaseAR_Status') IS NOT NULL
      DROP TABLE #TEMP_KHI_AgingCaseAR_Status;  
	  
CREATE TABLE #TEMP_KHI_AgingCaseAR_Status (
[MRN] bigint,
[CASEID] bigint,
[External MRN] varchar(20),
[PATIENTNAME] varchar(111),
[First Date of Injury] date,
[Date Of Birth] date,
[BUSINESSREGID] bigint,
[PROVIDER] varchar(100),
[CASETYPE] varchar(50),
[First DOS] datetime,
[Last DOS] datetime,
[BILLED] float(8),
[PAID] float(8),
[WRITEOFF] float(8),
[ADVANCE] float(8),
[OUTSTANDING] float(8),
[GFS_BILLED] float(8),
[GFS_PAID] float(8),
[GFS_WRITEOFF] float(8),
[GFS_ADVANCE] float(8),
[GFS_OUTSTANDING] float(8),
[COLLECTORNAME] varchar(41),
[Assign Verifier] varchar(41),
[Primary Attorney Name] varchar(200),
[Primary Attorney Address] varchar(200),
[Primary Attorney Phone] varchar(20),
[Primary Attorney Fax] varchar(20),
[Primary Attorney email] varchar(50),
[File Status] varchar(200),
[PI Lien] varchar(3),
[Signed By Patient] varchar(3),
[Signed By Attorney] varchar(3),
[data_server] nvarchar(6) null
);

insert into #TEMP_KHI_AgingCaseAR_Status([MRN] ,
[CASEID] ,[External MRN] ,[PATIENTNAME] ,[First Date of Injury] ,[Date Of Birth] ,[BUSINESSREGID] ,[PROVIDER] ,[CASETYPE] ,[First DOS] ,
[Last DOS] ,[BILLED] ,[PAID] ,[WRITEOFF] ,[ADVANCE] ,[OUTSTANDING] ,[GFS_BILLED] ,[GFS_PAID] ,[GFS_WRITEOFF] ,[GFS_ADVANCE] ,[GFS_OUTSTANDING],
[COLLECTORNAME] ,[Assign Verifier] ,[Primary Attorney Name] ,[Primary Attorney Address] ,[Primary Attorney Phone] ,[Primary Attorney Fax] ,
[Primary Attorney email] ,[File Status] ,[PI Lien] ,[Signed By Patient] ,[Signed By Attorney] ,[data_server]
)
EXEC [EPM].[DBO].[PBI_AgingCaseAR_Status]
	'',--@BUSINESSREGID
	'',--@LASTNAME
	'',--@MRN
	'',--@INSURANCE
	'',--@ACTIONSTATUS
	@Vfromdate,--@FROMDATE
	@Vtodate,--@TODATE
	'',--@COLLECTORRegid
	'',--@CASETYPEID
	'' ,--@CASETYPEID varchar(20)
	'' ,--@ProviderAccessList varchar(500)
	@OwnerID---@OwnerID BIGINT,
	@isSummary=0,	   -- @isSummary bigint=0  
	'',---@@StudyStatus VARCHAR(50)  
Create nonclustered index IX_TEMP_KHI_AgingCaseAR_Status_id on #TEMP_KHI_AgingCaseAR_Status(id);
delete from #TEMP_KHI_AgingCaseAR_Status where id in (select a.id from #TEMP_KHI_AgingCaseAR_Status a inner join  AgingCaseAR_Status b on a.id=b.id and b.data_server='KHI');

SET @cnt = 0;
SELECT @CNT = COUNT(ID)  FROM #TEMP_KHI_AgingCaseAR_Status;
select 'count = ', @cnt;

IF @CNT > 0 
BEGIN
-- BEFORE INSERT
select @IDSource=isnull(max(id),0) from [PBI_Reports].[dbo].[AgingCaseAR_Status] where data_server='KHI'; 
select @SourceCount=count(id) from [PBI_Reports].[dbo].[AgingCaseAR_Status] where data_server='KHI'; 
select 'BEFORE INSERT Source ID: ', @IDSource, ' Source Count:  ', @SourceCount;

INSERT INTO [PBI_Reports].[dbo].[AgingCaseAR_Status] 
([MRN] ,
[CASEID] ,[External MRN] ,[PATIENTNAME] ,[First Date of Injury] ,[Date Of Birth] ,[BUSINESSREGID] ,[PROVIDER] ,[CASETYPE] ,[First DOS] ,
[Last DOS] ,[BILLED] ,[PAID] ,[WRITEOFF] ,[ADVANCE] ,[OUTSTANDING] ,[GFS_BILLED] ,[GFS_PAID] ,[GFS_WRITEOFF] ,[GFS_ADVANCE] ,[GFS_OUTSTANDING],
[COLLECTORNAME] ,[Assign Verifier] ,[Primary Attorney Name] ,[Primary Attorney Address] ,[Primary Attorney Phone] ,[Primary Attorney Fax] ,
[Primary Attorney email] ,[File Status] ,[PI Lien] ,[Signed By Patient] ,[Signed By Attorney] ,[data_server]
)   
SELECT ([MRN] ,
[CASEID] ,[External MRN] ,[PATIENTNAME] ,[First Date of Injury] ,[Date Of Birth] ,[BUSINESSREGID] ,[PROVIDER] ,[CASETYPE] ,[First DOS] ,
[Last DOS] ,[BILLED] ,[PAID] ,[WRITEOFF] ,[ADVANCE] ,[OUTSTANDING] ,[GFS_BILLED] ,[GFS_PAID] ,[GFS_WRITEOFF] ,[GFS_ADVANCE] ,[GFS_OUTSTANDING],
[COLLECTORNAME] ,[Assign Verifier] ,[Primary Attorney Name] ,[Primary Attorney Address] ,[Primary Attorney Phone] ,[Primary Attorney Fax] ,
[Primary Attorney email] ,[File Status] ,[PI Lien] ,[Signed By Patient] ,[Signed By Attorney] ,[data_server]  )
'KHI'
 FROM #TEMP_KHI_AgingCaseAR_Status;

-- AFTER INSERT
select @IDTarget=max(id) from [PBI_Reports].[dbo].[BDRwithPayments_Rebill] where data_server='KHI';
select @TargetCount=count(id) from [PBI_Reports].[dbo].[BDRwithPayments_Rebill] where data_server='KHI';
select 'AFTER INSERT Target ID: ', @IDTarget, ' Target Count:  ', @TargetCount;


select @RowsProcessed=count(*) from #TEMP_KHI_AgingCaseAR_Status;

INSERT INTO [dbo].[AgingCaseAR_Status_log]
([FromDate],[ToDate],[RowsProcessed],[ProcessedOn],[FROM_ID],[TO_ID],
[ProcessStartedOn],[ProcessEndedOn],data_server)
VALUES (@fromdate, @todate, @RowsProcessed, getdate(), @IDSource, @IDTarget,
 @ProcessStartedOn,getdate(),'KHI');

	 --COMMIT TRANSACTION
END
END TRY
BEGIN CATCH
  --IF XACT_STATE() = 1
  --  COMMIT TRANSACTION
  --IF XACT_STATE() = -1
  --begin
INSERT INTO  [dbo].[AgingCaseAR_Status_err]
([ErrorDate],[ErrorNumber],[ErrorSeverity],[ErrorMessage],[ErrorLine],[ErrorProcedure]
,[FromDate],[ToDate],[RowsProcessed],[ProcessedOn],[FROM_ID],[TO_ID],[ProcessStartedOn],[ProcessEndedOn],data_server)
VALUES (GETDATE(), ERROR_NUMBER(), ERROR_SEVERITY(), ERROR_MESSAGE(), ERROR_LINE(), ERROR_PROCEDURE(),
@fromdate, @todate, @RowsProcessed, getdate(), @IDSource, @IDTarget,@ProcessStartedOn,getdate(),'KHI');

  SELECT  ERROR_NUMBER() AS ErrorNumber, ERROR_SEVERITY() AS Severity, 
  ERROR_MESSAGE() AS ErrorMessage, ERROR_LINE() AS ErrorLine, ERROR_PROCEDURE() AS ErrorProcedure;
  --end;
END CATCH
end;
/*

exec [KHI_PBI_AgingCaseAR_Status_JobScript] ;

*/



GO