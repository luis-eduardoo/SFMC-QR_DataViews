/*
[BR]
   NOTA:
    - Armazena informações sobre suas aberturas de e-mail, para quando você precisa saber quando alguém abriu seu e-mail.
   COLUNAS:
    - AccountID: Número de identificação da conta
    - OYBAccountID: Número de identificação para contas corporativas (MID)
    - JobID: Identificação para o envio do e-mail
    - ListID: Identificação da lista usada no envio
    - BatchID: Identificação do lote para lotes usados no envio
    - SubscriberID: Identificador exclusivo do seu assinante afetado pelo envio
    - SubscriberKey: Chave principal do seu assinante afetado pelo envio
    - EventDate: Data em que ocorreu a abertura
    - Domain: Domínio do assinante
    - IsUnique: Se a abertura é única ou repetida
    - TriggererSendDefinitionObjectID: Identificador do objeto para a definição de envio acionado
    - TriggeredSendCustomerKey: A chave do cliente para o envio acionado

[US]  
   NOTE:
    - Stores information about your Email Opens. For when you need to know when someone opened your email.
   COLUMNS:
    - AccountID: Your account ID number	
    - OYBAccountID: The account ID number for any related On-Your-Behalf accounts. This field applies to enterprise accounts only. (MID)
    - JobID: The job ID number for the email send
    - ListID: The list ID number for the list used in the send
    - BatchID: The batch ID number for any batches used in the send	
    - SubscriberID: The subscriber ID for the affected subscriber. This number represents the unique ID for each subscriber record
    - SubscriberKey: The subscriber key for the affected subscriber
    - EventDate: The date the open took place
    - Domain: The domain of the subscriber	
    - IsUnique: Whether the open is unique or repeated
    - TriggererSendDefinitionObjectID: The object ID for the triggered send definition
    - TriggeredSendCustomerKey: The customer key for the triggered send

    LINKS: 
    - https://help.salesforce.com/s/articleView?id=sf.mc_as_data_view_open.htm&type=5
    - https://mateuszdabrowski.pl/docs/config/sfmc-system-data-views/
    

*/

SELECT
    o.AccountID,
    o.OYBAccountID,
    o.JobID,
    o.ListID,
    o.BatchID,
    o.SubscriberID,
    o.SubscriberKey,
    o.EventDate,
    o.Domain,
    o.IsUnique,
    o.TriggererSendDefinitionObjectID,
    o.TriggeredSendCustomerKey
FROM   
    [_Open] o

/*[BR] DATA DA ÚLTIMA ABERTURA DE CADA ASSINANTE DENTRO DE UM PERÍODO*/
/*[US] DATE OF THE LAST OPENING OF EACH SUBSCRIBER WITHIN A PERIOD*/

SELECT DISTINCT
        o.SubscriberKey,
        s.EmailAddress,
        CONVERT(CHAR(10), MAX(o.EventDate),103) AS DT --> 103 = dd/mm/yyyy or 101 = mm/dd/yyyy
    FROM
        [_Open] o
    INNER JOIN 
        [_Subscribers] s ON o.SubscriberKey = s.SubscriberKey
    GROUP BY
         o.SubscriberKey, s.EmailAddress
    HAVING
         CONVERT(CHAR(10), MAX(o.EventDate),103) >= CONVERT(CHAR(10),GETDATE()-90,120) -- Mudar o "-90" de acordo com a sua necessidade


/*[BR] USUÁRIOS QUE NÃO ABRIRAM EM UM DETERMINADO PERÍODO PARA REPIQUE*/
/*[US] USERS WHO HAVE NOT OPENED IN A GIVEN PERIOD FOR REPLAY*/

SELECT
    s.SubscriberKey,
    d.[ContactKey]
FROM
    _Sent s
INNER JOIN
    [YOUR_DATA_EXTENSION] d ON s.SubscriberKey = d.[SubscriberKey]
WHERE
    CONVERT(VARCHAR(10), s.EventDate, 120) >= CONVERT(VARCHAR(10), GETDATE() -3, 120)
AND NOT EXISTS (SELECT '' FROM _Open o WHERE s.SubscriberKey = o.SubscriberKey)


