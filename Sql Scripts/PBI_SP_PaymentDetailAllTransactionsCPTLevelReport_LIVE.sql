



/*  
-- =============================================          
 AUTHOR    :    Shayan ul haq  
 OBJECT NAME :  [PBI_SP_PaymentDetailAllTransactionsCPTLevelReport_LIVE]   
 OBJECTTYPE  :  STORED PROCEDURE  
 CREATE DATE :  14th Feb, 2024  
 DESCRIPTION  : 
-- =============================================     
*/



CREATE PROCEDURE [dbo].[PBI_SP_PaymentDetailAllTransactionsCPTLevelReport_LIVE]
@ProviderAccessList varchar(Max),     
@BusinessRegID varchar(Max),     
@LastName varchar(100),     
@CheckNumber varchar(100),     
@INSURANCE varchar(100),     
@CASETYPEID varchar(20),     
@CPTCODE varchar(30),     
@PaymentFromDate varchar(10),     
@PaymentToDate varchar(10), 
@BILLING tinyint,    
@SETTELD_PAYMENT tinyint,     
@FOR_APPEAL tinyint,
@For_BoardSettlement tinyint,
@For_InHouseSettlement tinyint ,
@For_Re_Billing tinyint,
@ALL tinyint,     
@adjustment bit =0  ,
@MRN varchar(20),
@OWNERID varchar(5000),
@SUBOWNERID varchar(5000),
@USERREGID bigint   ,  
@date_type tinyint=1  ,      
@caseid  varchar(20)='',
@data_server varchar(3),
@IsInsert varchar(1) null --Y for data insertion data will be inserted into Table else only select.
AS
BEGIN
SET NOCOUNT ON;

BEGIN TRY

BEGIN TRAN;
IF OBJECT_ID('tempdb..#temp_paymentreport') IS NOT NULL
BEGIN
DROP TABLE #temp_paymentreport;
END
CREATE TABLE #temp_paymentreport(
  [ID] [bigint] IDENTITY(1,1) NOT NULL,
  [Paymentid] bigint ,
  [PATIENT_NAME] varchar(120),
  [MRN] bigint ,
  [BUSINESSREGID] bigint ,
  [PROVIDER] varchar(500) ,
  [CASEID] bigint ,
  [ADJNUMBER] varchar(20) ,
  [CASETYPE] varchar(50) ,
  [STUDY_NAME] varchar(1000) ,
  [STUDY_ID] bigint ,
  [STATUS] varchar(50) ,
  [CPTCODE] varchar(30) ,
  [BILLCPTCODEID] bigint ,
  [BILLDATE] datetime ,
  [DOS] varchar(64) ,
  [TOTAL_BILLED] float ,
  [INSURANCE_COMPANY] varchar(200),
  [PAYMENT] float ,
  [PAYMENTDATE] datetime ,
  [PAYMENT_TYPE] varchar(20) ,
  [CHECKNUMBER] varchar(50) ,
  [CHECKAMOUNT] float ,
  [TOTAL_PAID] float ,
  [TOTAL_WRITTEN_OFF] float ,
  [TOTAL_OUTSTANDING] float ,
  [OWNER] varchar(100) ,
  [SUB_OWNER] varchar(75) ,
  [PORTFOLIO] varchar(100) ,
  [REASON] varchar(200) ,
  [Case Validity] varchar(50) ,
  [Date Turned Invalid] date ,
  [Reason Of Invalid] varchar(50) ,
  [Payment Posted Date] datetime ,
  [Credit To Collector] varchar(150)  
  );


  IF(@data_server IN ('ALL','KHI',''))
BEGIN
INSERT INTO #temp_paymentreport
(
  [Paymentid], [PATIENT_NAME], [MRN],[BUSINESSREGID] ,[PROVIDER] ,[CASEID],[ADJNUMBER], [CASETYPE] ,[STUDY_NAME] ,[STUDY_ID]
  ,[STATUS] ,[CPTCODE] ,[BILLCPTCODEID] ,[BILLDATE] ,[DOS] ,[TOTAL_BILLED] ,[INSURANCE_COMPANY] ,[PAYMENT] ,[PAYMENTDATE],[PAYMENT_TYPE] ,
  [CHECKNUMBER] ,[CHECKAMOUNT] ,[TOTAL_PAID] ,[TOTAL_WRITTEN_OFF] ,[TOTAL_OUTSTANDING] ,[OWNER] ,[SUB_OWNER] ,[PORTFOLIO] ,[REASON] 
  ,[Case Validity] ,[Date Turned Invalid] ,[Reason Of Invalid] ,[Payment Posted Date],[Credit To Collector]
  )

  EXEC 
[EPM].[DBO].[PBI_ PaymentDetailAllTransactionsCPTLevel_Live]
@OWNER_ID  =@OWNER_ID, -- Owner ID for GFS    
@BusinessRegID =NULL,    
@SUBOWNER_ID =NULL,  
@PaymentFromdate =@PaymentFromDate,    
@PaymentTodate =@PaymentTODATE,
@datecheck =2,--@DateCheck =(2 for BillDate) (3 for Bill Created Date)
@USERREGID ='1' ,
@caseid =''  ,
@linkSrv = '',
@businessregid = '', 
@MRN = '', 
@caseid = '',
@CASETYPEID = '',
@CPTCODE = '',
@SETTELD_PAYMENT = '',
@FOR_APPEAL = '',
@For_BoardSettlement = '',
@For_InHouseSettlement = '',
@For_Re_Billing = '',
@adjustment  = '',
@CheckNumber= '',
@INSURANCE= '',
@BILLING = '',
@ALL = '',
@linkSrv = ''

update #paymentreport SET data_server='KHI' where data_server=null
END

IF(@data_server IN ('ALL','IWP',''))
BEGIN
INSERT INTO #temp_paymentreport
(
 [Paymentid], [PATIENT_NAME], [MRN],[BUSINESSREGID] ,[PROVIDER] ,[CASEID],[ADJNUMBER], [CASETYPE] ,[STUDY_NAME] ,[STUDY_ID]
  ,[STATUS] ,[CPTCODE] ,[BILLCPTCODEID] ,[BILLDATE] ,[DOS] ,[TOTAL_BILLED] ,[INSURANCE_COMPANY] ,[PAYMENT] ,[PAYMENTDATE],[PAYMENT_TYPE] ,
  [CHECKNUMBER] ,[CHECKAMOUNT] ,[TOTAL_PAID] ,[TOTAL_WRITTEN_OFF] ,[TOTAL_OUTSTANDING] ,[OWNER] ,[SUB_OWNER] ,[PORTFOLIO] ,[REASON] 
  ,[Case Validity] ,[Date Turned Invalid] ,[Reason Of Invalid] ,[Payment Posted Date],[Credit To Collector]
  )

  EXEC 
[EPM_IWP].[DBO].[PBI_ PaymentDetailAllTransactionsCPTLevel_Live]
@OWNER_ID  =@OWNER_ID, -- Owner ID for GFS    
@BusinessRegID =NULL,    
@SUBOWNER_ID =NULL,  
@PaymentFromdate =@PaymentFromDate,    
@PaymentTodate =@PaymentTODATE,
@datecheck =2,--@DateCheck =(2 for BillDate) (3 for Bill Created Date)
@USERREGID ='1' ,
@caseid =''  ,
@linkSrv = '',
@businessregid = '', 
@MRN = '', 
@caseid = '',
@CASETYPEID = '',
@CPTCODE = '',
@SETTELD_PAYMENT = '',
@FOR_APPEAL = '',
@For_BoardSettlement = '',
@For_InHouseSettlement = '',
@For_Re_Billing = '',
@adjustment  = '',
@CheckNumber= '',
@INSURANCE= '',
@BILLING = '',
@ALL = '',
@linkSrv = ''
update #paymentreport SET data_server='IWP' where data_server=null
END

IF(@data_server IN ('ALL','PI',''))
BEGIN
INSERT INTO #temp_paymentreport
(
 [Paymentid], [PATIENT_NAME], [MRN],[BUSINESSREGID] ,[PROVIDER] ,[CASEID],[ADJNUMBER], [CASETYPE] ,[STUDY_NAME] ,[STUDY_ID]
  ,[STATUS] ,[CPTCODE] ,[BILLCPTCODEID] ,[BILLDATE] ,[DOS] ,[TOTAL_BILLED] ,[INSURANCE_COMPANY] ,[PAYMENT] ,[PAYMENTDATE],[PAYMENT_TYPE] ,
  [CHECKNUMBER] ,[CHECKAMOUNT] ,[TOTAL_PAID] ,[TOTAL_WRITTEN_OFF] ,[TOTAL_OUTSTANDING] ,[OWNER] ,[SUB_OWNER] ,[PORTFOLIO] ,[REASON] 
  ,[Case Validity] ,[Date Turned Invalid] ,[Reason Of Invalid] ,[Payment Posted Date],[Credit To Collector]
  )

  EXEC 
[EPM_PI].[DBO].[PBI_ PaymentDetailAllTransactionsCPTLevel_Live]
@OWNER_ID  =@OWNER_ID, -- Owner ID for GFS    
@BusinessRegID =NULL,    
@SUBOWNER_ID =NULL,  
@PaymentFromdate =@PaymentFromDate,    
@PaymentTodate =@PaymentTODATE,
@datecheck =2,--@DateCheck =(2 for BillDate) (3 for Bill Created Date)
@USERREGID ='1' ,
@caseid =''  ,
@linkSrv = '',
@businessregid = '', 
@MRN = '', 
@caseid = '',
@CASETYPEID = '',
@CPTCODE = '',
@SETTELD_PAYMENT = '',
@FOR_APPEAL = '',
@For_BoardSettlement = '',
@For_InHouseSettlement = '',
@For_Re_Billing = '',
@adjustment  = '',
@CheckNumber= '',
@INSURANCE= '',
@BILLING = '',
@ALL = '',
@linkSrv = ''
update #paymentreport SET data_server='PI' where data_server=null
END

IF(@data_server IN ('ALL','PHY',''))
BEGIN
INSERT INTO #temp_paymentreport
(
 [Paymentid], [PATIENT_NAME], [MRN],[BUSINESSREGID] ,[PROVIDER] ,[CASEID],[ADJNUMBER], [CASETYPE] ,[STUDY_NAME] ,[STUDY_ID]
  ,[STATUS] ,[CPTCODE] ,[BILLCPTCODEID] ,[BILLDATE] ,[DOS] ,[TOTAL_BILLED] ,[INSURANCE_COMPANY] ,[PAYMENT] ,[PAYMENTDATE],[PAYMENT_TYPE] ,
  [CHECKNUMBER] ,[CHECKAMOUNT] ,[TOTAL_PAID] ,[TOTAL_WRITTEN_OFF] ,[TOTAL_OUTSTANDING] ,[OWNER] ,[SUB_OWNER] ,[PORTFOLIO] ,[REASON] 
  ,[Case Validity] ,[Date Turned Invalid] ,[Reason Of Invalid] ,[Payment Posted Date],[Credit To Collector]
  )

  EXEC 
[EPM_PHY].[DBO].[PBI_ PaymentDetailAllTransactionsCPTLevel_Live]
@OWNER_ID  =@OWNER_ID, -- Owner ID for GFS    
@BusinessRegID =NULL,    
@SUBOWNER_ID =NULL,  
@PaymentFromdate =@PaymentFromDate,    
@PaymentTodate =@PaymentTODATE,
@datecheck =2,--@DateCheck =(2 for BillDate) (3 for Bill Created Date)
@USERREGID ='1' ,
@caseid =''  ,
@linkSrv = '',
@businessregid = '', 
@MRN = '', 
@caseid = '',
@CASETYPEID = '',
@CPTCODE = '',
@SETTELD_PAYMENT = '',
@FOR_APPEAL = '',
@For_BoardSettlement = '',
@For_InHouseSettlement = '',
@For_Re_Billing = '',
@adjustment  = '',
@CheckNumber= '',
@INSURANCE= '',
@BILLING = '',
@ALL = '',
@linkSrv = ''
update #paymentreport SET data_server='PHY' where data_server=null
END