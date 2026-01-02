/*
-- =============================================                                                                          

 AUTHOR    :    SHAYAN UL HAQ
 OBJECT NAME :  [PBI_PBI_BDRwithPayments_Rebill_JobScript] 
 OBJECTTYPE  :  STORED PROCEDURE                                                                  
 CREATE DATE :  18th MARCH, 2024
 DESCRIPTION  : This can be scheduled on any time interval

 N O T E:		THIS WILL GET KHI DATA TO POPULATE TO KARACHI POWER PBI
-- =============================================                                                                     

*/

CREATE PROCEDURE [dbo].[PBI_PBI_BDRwithPayments_Rebill_JobScript]                                                  

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

SELECT @fromdate=max(ID) FROM [PBI_Reports].[dbo].[BDRwithPayments_Billing] where data_server='KHI';
SET @Vfromdate = convert(varchar, @fromdate, 25);
--select @fromdate = FORMAT(@fromdate, 'yyyy-MM-dd hh:mm tt');
select @todate = FORMAT(getdate(), 'yyyy-MM-dd hh:mm tt');
SET @Vtodate = convert(varchar,GETDATE(), 25);
select 'Form Date: ', @fromdate, ' To Date: ', @todate;

--BEGIN DISTRIBUTED TRANSACTION
BEGIN TRY
 -- succeeds

IF OBJECT_ID('tempdb..#TEMP_KHI_REBILLINGREPORT') IS NOT NULL
      DROP TABLE #TEMP_KHI_REBILLINGREPORT;  
	  
CREATE TABLE #TEMP_KHI_REBILLINGREPORT (
[PATIENTREGID] bigint,
[PATIENT_NAME] varchar(111),
[CASETYPE] varchar(50),
[DATEOFBIRTH] smalldatetime,
[EMPLOYER] varchar(100),
[BUSINESSID] varchar(100),
[BUSINESSREGID] bigint,
[BUSINESSNAME] varchar(100),
[PROVIDER TAX ID] varchar(70),
[PROVIDER NPI] varchar(30),
[DATEOFSERVICE] nvarchar(MAX),
[DATE OF INJURY] nvarchar(MAX),
[APPOINTMENTTYPE] varchar(MAX),
[AMOUNTBILLED] float(8),
[PAID] float(8),
[WRITEOFF] float(8),
[OUTSTANDING] float(8),
[OMFS] float(8),
[Market_Values] float(8),
[BILLDATE] nvarchar(MAX),
[INSURANCE NAME] varchar(100),
[INSURANCE ADDRESS] varchar(502),
[CITY] varchar(50),
[STATE] varchar(2),
[ZIPCODE] varchar(10),
[CLAIM_NUMBER] varchar(100),
[PHONE] varchar(50),
[ATTORNEY_NAME] varchar(200),
[ATTORNEY ADDRESS] varchar(200),
[BUSINESS FACILITY NAME] varchar(100),
[BUSINESS FACILITY ADDRESS] varchar(200),
[BUSINESS FACILITY CITY] varchar(100),
[BUSINESS FACILITY STATE] varchar(50),
[BUSINESS FACILITY ZIPCODE] varchar(10),
[BUSINESS FACILITY NPI] varchar(20),
[BUSINESS PHYSICIAN NAME] varchar(41),
[BUSINESS PHYSICIAN NPI] varchar(20),
[BUSINESS PHYSICIAN LICENSE] varchar(20),
[BUSINESS PHYSICIAN Taxonomy Code] varchar(20),
[REFERRING PHYSICIAN NAME] varchar(101),
[REFERRING PHYSICIAN NPI] varchar(20),
[REFERRING PHYSICIAN LICENSE] varchar(20),
[CASEID] bigint,
[STUDY_ID] bigint,
[EXTERNALCASEID] bigint,
[EXTERNAL MRN] varchar(20),
[OWNER_NAME] varchar(100),
[PORTFOLIO_NAME] varchar(100),
[SUB OWNER_NAME] varchar(75),
[STATUS] varchar(50),
[STATUS_CHANGED_BY] varchar(41),
[STATUS_CHANGED_ON] nvarchar(MAX),
[BILLCREATEDDATE] nvarchar(MAX),
[BILLCREATEDBY] varchar(41),
[Service Type] varchar(30),
[Bill Submission Status] varchar(30),
[Bill Submission Date] date,
[Bill Submission Type] varchar(15),
[L3A_Payor_Status] varchar(50),
[L3A_Payor_Date] datetime,
[L3B_Payor_Status] varchar(50),
[L3B_Payor_Date] datetime,
[Payment_Allowed] float(8),
[Reason_for_Denial] nvarchar(MAX),
[EDI_status] varchar(50),
[File_response] varchar(50),
[response_date] datetime,
[SBR_TYPE] varchar(10),
[data_server] nvarchar(6) null
);

insert into #TEMP_KHI_REBILLINGREPORT([PATIENTREGID] ,
[PATIENT_NAME] ,[CASETYPE] ,[DATEOFBIRTH] ,[EMPLOYER] ,[BUSINESSID] ,[BUSINESSREGID] ,[BUSINESSNAME] ,[PROVIDER TAX ID] ,
[PROVIDER NPI],[DATEOFSERVICE] ,[DATE OF INJURY],[APPOINTMENTTYPE] ,[AMOUNTBILLED] ,[PAID] ,[WRITEOFF] ,
[OUTSTANDING] ,[OMFS] ,[Market_Values],[BILLDATE] ,[INSURANCE NAME] ,[INSURANCE ADDRESS] ,[CITY] ,[STATE] ,[ZIPCODE] ,[CLAIM_NUMBER] ,
[PHONE] ,[ATTORNEY_NAME] ,[ATTORNEY ADDRESS],[BUSINESS FACILITY NAME] ,[BUSINESS FACILITY ADDRESS] ,[BUSINESS FACILITY CITY],[BUSINESS FACILITY STATE] ,
[BUSINESS FACILITY ZIPCODE] ,[BUSINESS FACILITY NPI] ,[BUSINESS PHYSICIAN NAME] ,[BUSINESS PHYSICIAN NPI] ,[BUSINESS PHYSICIAN LICENSE] ,
[BUSINESS PHYSICIAN Taxonomy Code] ,[REFERRING PHYSICIAN NAME] ,[REFERRING PHYSICIAN NPI] ,[REFERRING PHYSICIAN LICENSE] ,
[CASEID] ,[STUDY_ID] ,[EXTERNALCASEID] ,[EXTERNAL MRN] ,[OWNER_NAME] ,[PORTFOLIO_NAME] ,[SUB OWNER_NAME] ,
[STATUS],[STATUS_CHANGED_BY] ,[STATUS_CHANGED_ON] ,[BILLCREATEDDATE] ,[BILLCREATEDBY] ,[Service Type] ,
[Bill Submission Status] ,[Bill Submission Date] ,[Bill Submission Type] ,[L3A_Payor_Status] ,[L3A_Payor_Date] ,
[L3B_Payor_Status],[L3B_Payor_Date],[Payment_Allowed] ,[Reason_for_Denial] ,[EDI_status] ,[File_response] ,
[response_date] ,[SBR_TYPE] ,[data_server] 
)
EXEC [EPM].[DBO].[PBI_BDRwithPayments_Rebill]
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
	'' ,--@ProviderAccessList varchar(500)
	'',---@@StudyStatus VARCHAR(50)  
Create nonclustered index IX_TEMP_KHI_REBILLINGREPORT_id on #TEMP_KHI_REBILLINGREPORT(id);
delete from #TEMP_KHI_REBILLINGREPORT where id in (select a.id from #TEMP_KHI_REBILLINGREPORT a inner join  BDRwithPayments_Rebill b on a.id=b.id and b.data_server='KHI');

SET @cnt = 0;
SELECT @CNT = COUNT(ID)  FROM #TEMP_KHI_REBILLINGREPORT;
select 'count = ', @cnt;

IF @CNT > 0 
BEGIN
-- BEFORE INSERT
select @IDSource=isnull(max(id),0) from [PBI_Reports].[dbo].[BDRwithPayments_Rebill] where data_server='KHI'; 
select @SourceCount=count(id) from [PBI_Reports].[dbo].[BDRwithPayments_Rebill] where data_server='KHI'; 
select 'BEFORE INSERT Source ID: ', @IDSource, ' Source Count:  ', @SourceCount;

INSERT INTO [PBI_Reports].[dbo].[BDRwithPayments_Rebill] 
([PATIENTREGID] ,
[PATIENT_NAME] ,[CASETYPE] ,[DATEOFBIRTH] ,[EMPLOYER] ,[BUSINESSID] ,[BUSINESSREGID] ,[BUSINESSNAME] ,[PROVIDER TAX ID] ,
[PROVIDER NPI],[DATEOFSERVICE] ,[DATE OF INJURY],[APPOINTMENTTYPE] ,[AMOUNTBILLED] ,[PAID] ,[WRITEOFF] ,
[OUTSTANDING] ,[OMFS] ,[Market_Values],[BILLDATE] ,[INSURANCE NAME] ,[INSURANCE ADDRESS] ,[CITY] ,[STATE] ,[ZIPCODE] ,[CLAIM_NUMBER] ,
[PHONE] ,[ATTORNEY_NAME] ,[ATTORNEY ADDRESS],[BUSINESS FACILITY NAME] ,[BUSINESS FACILITY ADDRESS] ,[BUSINESS FACILITY CITY],[BUSINESS FACILITY STATE] ,
[BUSINESS FACILITY ZIPCODE] ,[BUSINESS FACILITY NPI] ,[BUSINESS PHYSICIAN NAME] ,[BUSINESS PHYSICIAN NPI] ,[BUSINESS PHYSICIAN LICENSE] ,
[BUSINESS PHYSICIAN Taxonomy Code] ,[REFERRING PHYSICIAN NAME] ,[REFERRING PHYSICIAN NPI] ,[REFERRING PHYSICIAN LICENSE] ,
[CASEID] ,[STUDY_ID] ,[EXTERNALCASEID] ,[EXTERNAL MRN] ,[OWNER_NAME] ,[PORTFOLIO_NAME] ,[SUB OWNER_NAME] ,
[STATUS],[STATUS_CHANGED_BY] ,[STATUS_CHANGED_ON] ,[BILLCREATEDDATE] ,[BILLCREATEDBY] ,[Service Type] ,
[Bill Submission Status] ,[Bill Submission Date] ,[Bill Submission Type] ,[L3A_Payor_Status] ,[L3A_Payor_Date] ,
[L3B_Payor_Status],[L3B_Payor_Date],[Payment_Allowed] ,[Reason_for_Denial] ,[EDI_status] ,[File_response] ,
[response_date] ,[SBR_TYPE] ,[data_server] 
)   
SELECT [PATIENTREGID] ,
[PATIENT_NAME] ,[CASETYPE] ,[DATEOFBIRTH] ,[EMPLOYER] ,[BUSINESSID] ,[BUSINESSREGID] ,[BUSINESSNAME] ,[PROVIDER TAX ID] ,
[PROVIDER NPI],[DATEOFSERVICE] ,[DATE OF INJURY],[APPOINTMENTTYPE] ,[AMOUNTBILLED] ,[PAID] ,[WRITEOFF] ,
[OUTSTANDING] ,[OMFS] ,[Market_Values],[BILLDATE] ,[INSURANCE NAME] ,[INSURANCE ADDRESS] ,[CITY] ,[STATE] ,[ZIPCODE] ,[CLAIM_NUMBER] ,
[PHONE] ,[ATTORNEY_NAME] ,[ATTORNEY ADDRESS],[BUSINESS FACILITY NAME] ,[BUSINESS FACILITY ADDRESS] ,[BUSINESS FACILITY CITY],[BUSINESS FACILITY STATE] ,
[BUSINESS FACILITY ZIPCODE] ,[BUSINESS FACILITY NPI] ,[BUSINESS PHYSICIAN NAME] ,[BUSINESS PHYSICIAN NPI] ,[BUSINESS PHYSICIAN LICENSE] ,
[BUSINESS PHYSICIAN Taxonomy Code] ,[REFERRING PHYSICIAN NAME] ,[REFERRING PHYSICIAN NPI] ,[REFERRING PHYSICIAN LICENSE] ,
[CASEID] ,[STUDY_ID] ,[EXTERNALCASEID] ,[EXTERNAL MRN] ,[OWNER_NAME] ,[PORTFOLIO_NAME] ,[SUB OWNER_NAME] ,
[STATUS],[STATUS_CHANGED_BY] ,[STATUS_CHANGED_ON] ,[BILLCREATEDDATE] ,[BILLCREATEDBY] ,[Service Type] ,
[Bill Submission Status] ,[Bill Submission Date] ,[Bill Submission Type] ,[L3A_Payor_Status] ,[L3A_Payor_Date] ,
[L3B_Payor_Status],[L3B_Payor_Date],[Payment_Allowed] ,[Reason_for_Denial] ,[EDI_status] ,[File_response] ,
[response_date] ,[SBR_TYPE] ,[data_server]  ,
,'KHI'
 FROM #TEMP_KHI_REBILLINGREPORT;

-- AFTER INSERT
select @IDTarget=max(id) from [PBI_Reports].[dbo].[BDRwithPayments_Rebill] where data_server='KHI';
select @TargetCount=count(id) from [PBI_Reports].[dbo].[BDRwithPayments_Rebill] where data_server='KHI';
select 'AFTER INSERT Target ID: ', @IDTarget, ' Target Count:  ', @TargetCount;


select @RowsProcessed=count(*) from #TEMP_KHI_REBILLINGREPORT;

INSERT INTO [dbo].[BDRwithPayments_Rebill_log]
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
INSERT INTO  [dbo].[BDRwithPayments_Rebill_err]
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

exec [KHI_PBI_BDRwithPayments_Rebill_JobScript] ;

*/



GO