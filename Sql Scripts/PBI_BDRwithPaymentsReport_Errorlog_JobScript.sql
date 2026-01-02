/*
-- =============================================        

 AUTHOR    :    SHAYAN UL HAQ
 OBJECT NAME :  [PBI_PaymentsReportByOwner_Live_Errorlog_JobScript] 
 OBJECTTYPE  :  STORED PROCEDURE
 CREATE DATE :  15th March, 2024
 DESCRIPTION  : This can be scheduled on Daily

-- =============================================   

*/
CREATE PROCEDURE [dbo].[PBI_PaymentsReportByOwner_JobScript]                                                  

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

SELECT @fromdate=max(actiondate) FROM [PBI_Reports].[dbo].[PaymentsReportByOwner_Live] where data_server='KHI';
SET @Vfromdate = convert(varchar, @fromdate, 25);
--select @fromdate = FORMAT(@fromdate, 'yyyy-MM-dd hh:mm tt');
select @todate = FORMAT(getdate(), 'yyyy-MM-dd hh:mm tt');
SET @Vtodate = convert(varchar,GETDATE(), 25);
select 'Form Date: ', @fromdate, ' To Date: ', @todate;

--BEGIN DISTRIBUTED TRANSACTION
BEGIN TRY
 -- succeeds

IF OBJECT_ID('tempdb..#TEMP_KHI_PaymentsReportByOwner') IS NOT NULL
      DROP TABLE #TEMP_KHI_PaymentsReportByOwner;  
	  
CREATE TABLE #TEMP_KHI_PaymentsReportByOwner (
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
    [Paymentid] [bigint] NULL,
	[PATIENT_NAME] [varchar](120) NULL,
	[MRN] [bigint] NULL,
	[BUSINESSREGID] [bigint] NULL,
	[PROVIDER] [varchar](500) NULL,
	[CASEID] [bigint] NULL,
	[ADJNUMBER] [varchar](20) NULL,
	[CASETYPE] [varchar](50) NULL,
	[STUDY_NAME] [varchar](1000) NULL,
	[STUDY_ID] [bigint] NULL,
	[STATUS] [varchar](50) NULL,
	[CPTCODE] [varchar](30) NULL,
	[BILLCPTCODEID] [bigint] NULL,
	[BILLDATE] [datetime] NULL,
	[DOS] [varchar](64) NULL,
	[TOTAL_BILLED] [float] NULL,
	[INSURANCE_COMPANY] [varchar](200) NULL,
	[PAYMENT] [float] NULL,
	[PAYMENTDATE] [datetime] NULL,
	[PAYMENT_TYPE] [varchar](20) NULL,
	[CHECKNUMBER] [varchar](50) NULL,
	[CHECKAMOUNT] [float] NULL,
	[TOTAL_PAID] [float] NULL,
	[TOTAL_WRITTEN_OFF] [float] NULL,
	[TOTAL_OUTSTANDING] [float] NULL,
	[OWNER] [varchar](100) NULL,
	[SUB_OWNER] [varchar](75) NULL,
	[PORTFOLIO] [varchar](100) NULL,
	[REASON] [varchar](200) NULL,
	[Case Validity] [varchar](50) NULL,
	[Date Turned Invalid] [date] NULL,
	[Reason Of Invalid] [varchar](50) NULL,[Payment Posted Date]  [datetime] NULL
	,[Credit To Collector] [varchar](150) NULL 
);
);

insert into #TEMP_KHI_PaymentsReportByOwner(
      [ID] ,
    [Paymentid] ,
	[PATIENT_NAME] ,
	[MRN]  ,
	[BUSINESSREGID]  ,
	[PROVIDER] ,
	[CASEID] ,
	[ADJNUMBER] ,
	[CASETYPE] ,
	[STUDY_NAME] ,
	[STUDY_ID] ,
	[STATUS] ,
	[CPTCODE] ,
	[BILLCPTCODEID] ,
	[BILLDATE] ,
	[DOS] ,
	[TOTAL_BILLED] ,
	[INSURANCE_COMPANY] ,
	[PAYMENT],
	[PAYMENTDATE] ,
	[PAYMENT_TYPE] ,
	[CHECKNUMBER] ,
	[CHECKAMOUNT] ,
	[TOTAL_PAID] ,
	[TOTAL_WRITTEN_OFF],
	[TOTAL_OUTSTANDING] ,
	[OWNER] ,
	[SUB_OWNER] ,
	[PORTFOLIO] ,
	[REASON] ,
	[Case Validity] ,
	[Date Turned Invalid] ,
	[Reason Of Invalid] ,[Payment Posted Date] 
	,[Credit To Collector] 
);
EXEC [EPM].[DBO].[PaymentsReportByOwner_Live]
	'',--@BUSINESSREGID
	'',--@LASTNAME
	'',--@MRN
	'',--@INSURANCE
	'',--@ACTIONSTATUS
	@Vfromdate,--@FROMDATE
	@Vtodate,--@TODATE
	'',--@COLLECTORRegid
	''--@CASETYPEID

Create nonclustered index IX_TEMPACTIONSTATUS_actiontakenid on #TEMP_KHI_PaymentsReportByOwner(id);
delete from #TEMP_KHI_PaymentsReportByOwner where id in (select id from #TEMP_KHI_PaymentsReportByOwner a inner join PaymentsReportByOwner_Live b on a.id=b.id and b.data_server='KHI');

SET @cnt = 0;
SELECT @CNT = COUNT(ID)  FROM #TEMP_KHI_PaymentsReportByOwner;
select 'count = ', @cnt;

IF @CNT > 0 
BEGIN
-- BEFORE INSERT
select @IDSource=isnull(max(id),0) from [PBI_Reports].[dbo].[ActionStatusActivity] where data_server='KHI'; 
select @SourceCount=count(id) from [PBI_Reports].[dbo].[ActionStatusActivity] where data_server='KHI'; 
select 'BEFORE INSERT Source ID: ', @IDSource, ' Source Count:  ', @SourceCount;

INSERT INTO [PBI_Reports].[dbo].[PaymentsReportByOwner_Live] 
(
      [ID] ,
    [Paymentid] ,
	[PATIENT_NAME] ,
	[MRN]  ,
	[BUSINESSREGID]  ,
	[PROVIDER] ,
	[CASEID] ,
	[ADJNUMBER] ,
	[CASETYPE] ,
	[STUDY_NAME] ,
	[STUDY_ID] ,
	[STATUS] ,
	[CPTCODE] ,
	[BILLCPTCODEID] ,
	[BILLDATE] ,
	[DOS] ,
	[TOTAL_BILLED] ,
	[INSURANCE_COMPANY] ,
	[PAYMENT],
	[PAYMENTDATE] ,
	[PAYMENT_TYPE] ,
	[CHECKNUMBER] ,
	[CHECKAMOUNT] ,
	[TOTAL_PAID] ,
	[TOTAL_WRITTEN_OFF],
	[TOTAL_OUTSTANDING] ,
	[OWNER] ,
	[SUB_OWNER] ,
	[PORTFOLIO] ,
	[REASON] ,
	[Case Validity] ,
	[Date Turned Invalid] ,
	[Reason Of Invalid] ,[Payment Posted Date] 
	,[Credit To Collector]) 'KHI'
 FROM #TEMP_KHI_PaymentsReportByOwner;

-- AFTER INSERT
select @IDTarget=max(id) from [PBI_Reports].[dbo].[PaymentsReportByOwner_Live] where data_server='KHI';
select @TargetCount=count(id) from [PBI_Reports].[dbo].[PaymentsReportByOwner_Live] where data_server='KHI';
select 'AFTER INSERT Target ID: ', @IDTarget, ' Target Count:  ', @TargetCount;


select @RowsProcessed=count(*) from #TEMP_KHI_PaymentsReportByOwner;

INSERT INTO [dbo].[PaymentsReportByOwner_LOG]
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
INSERT INTO  [dbo].[PaymentsReportByOwner_ERR]
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

exec [KHI_PBI_PaymentsReportByOwner_JobScript] ;

*/



GO