/*
[BR]
   NOTA:
    - Armazena dados sobre eventos de cancelamento de inscrição.
   COLUNAS:
    - AccountID: Número de identificação da conta
    - OYBAccountID: Número de identificação para contas corporativas (MID)
    - JobID: Identificação para o envio do e-mail
    - ListID: Identificação da lista usada no envio
    - BatchID: Identificação do lote para lotes usados no envio
    - SubscriberID: Identificador exclusivo do seu assinante afetado pelo envio
    - SubscriberKey: Chave principal do seu assinante afetado pelo envio
    - IsUnique: Se o evento é único ou repetido
    - EventDate: Data em que ocorreu o cancelamento da inscrição
    - Domain: Domínio do assinante


[US]  
   NOTE:
    - Stores data about unsubscribe events.
   COLUMNS:
    - AccountID: Your account ID number	
    - OYBAccountID: The account ID number for any related On-Your-Behalf accounts. This field applies to enterprise accounts only. (MID)
    - JobID: The job ID number for the email send
    - ListID: The list ID number for the list used in the send
    - BatchID: The batch ID number for any batches used in the send	
    - SubscriberID: The subscriber ID for the affected subscriber. This number represents the unique ID for each subscriber record
    - SubscriberKey: The subscriber key for the affected subscriber
    - EventDate: The date the unsubscribe took place
    - IsUnique: Whether the event is unique or repeated
    - Domain: The domain of the subscriber	


    LINKS: 
    - https://help.salesforce.com/s/articleView?id=sf.mc_as_data_view_sent.htm&type=5
    - https://mateuszdabrowski.pl/docs/config/sfmc-system-data-views/  
*/

SELECT
    u.AccountID,
    u.OYBAccountID,
    u.JobID,
    u.ListID,
    u.BatchID,
    u.SubscriberID,
    u.SubscriberKey,
    u.EventDate,
    u.IsUnique,
    u.Domain
FROM [_Unsubscribe] u

/*[BR] OPT-OUT DOS ÚLTIMOS 30 DIAS*/
/*[US] OPT-OUT OF THE LAST 30 DAYS*/

   SELECT DISTINCT
        bu.SubscriberKey,
        s.EmailAddress,
        'Unsubscribed' AS STATUS,
        CONVERT(CHAR(10),DATEADD(hour, -3, bu.UnsubdateUTC),103) AS UnsubDate --> 103 = dd/mm/yyyy or 101 = mm/dd/yyyy
    FROM  
        ent._BusinessUnitUnsubscribes bu 
    INNER JOIN 
        ent._Subscribers s ON bu.subscriberkey = s.subscriberkey
    WHERE
        CONVERT(CHAR(10),DATEADD(HOUR, -3, bu.UnsubdateUTC),120) >= CONVERT(CHAR(10),GETDATE()-30,120)

/*[BR] CONTAGEM DE DIAS ATÉ O ASSINANTE VIRAR OPT-OUT*/
/*[US] COUNT OF DAYS UNTIL THE SUBSCRIBER BECOMES OPT-OUT*/

SELECT
        s.Subscriberkey,
        DATEDIFF(day,CONVERT(CHAR(10), s.DateJoined,120),CONVERT(CHAR(10),DATEADD(HOUR, -3, bu.UnsubDateUTC),120)) AS QtddDiasUnsub, 
        CONVERT(CHAR(10),DATEADD(hour, -3, s.DateJoined),103) AS SubsDate, --> 103 = dd/mm/yyyy or 101 = mm/dd/yyyy
        CONVERT(CHAR(10),DATEADD(hour, -3, bu.UnsubdateUTC),103) AS UnsubDate --> 103 = dd/mm/yyyy or 101 = mm/dd/yyyy
    FROM 
        ENT._Subscribers s 
    INNER JOIN
        ENT._BusinessUnitUnsubscribes bu ON s.Subscriberkey = bu.subscriberkey

