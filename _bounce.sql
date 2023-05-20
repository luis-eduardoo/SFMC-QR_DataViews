/*
[BR]
   NOTA:
    - Armazena informações sobre os bounces da conta
   COLUNAS:
    - AccountID: Número de identificação da conta
    - OYBAccountID: Número de identificação para contas corporativas (MID)
    - JobID: Identificação para o envio do e-mail
    - ListID: Identificação da lista usada no envio
    - BatchID: Identificação do lote para lotes usados no envio
    - SubscriberID: Identificador exclusivo do seu assinante afetado pelo envio
    - SubscriberKey: A chave do assinante para o assinante afetado
    - EventDate: Data em que ocorreu o bounce
    - Domain: Domínio do assinante
    - IsUnique: Se o evento é único ou repetido
    - BounceCategoryID: Identificação da categoria do bounce
    - BounceCategory: Categoria do bounce
    - BounceSubcategoryID: Identificação da subcategoria do bounce	
    - BounceSubcategory: Subcategoria do bounce
    - BounceTypeID: Identificação do tipo do bounce	
    - BounceType: Tipo de rejeição que ocorreu
    - SMTPBounceReason: O motivo da devolução retransmitida pelo sistema
    - SMTPMessage: A mensagem sobre a devolução do sistema
    - SMTPCode: O código de erro para a devolução do sistema
    - TriggererSendDefinitionObjectID: Identificador do objeto para a definição de envio acionado
    - TriggeredSendCustomerKey: A chave do cliente para o envio acionado

[US]  
   NOTE:
    - Stores information about your Email Bounces. Best place in Marketing Cloud to understand why your messages are not getting delivered.
   COLUMNS:
    - AccountID: Your account ID number	
    - OYBAccountID: The account ID number for any related On-Your-Behalf accounts. This field applies to enterprise accounts only. (MID)
    - JobID: The job ID number for the email send
    - ListID: The list ID number for the list used in the send
    - BatchID: The batch ID number for any batches used in the send	
    - SubscriberID: The subscriber ID for the affected subscriber. This number represents the unique ID for each subscriber record
    - SubscriberKey: The subscriber key for the affected subscriber
    - EventDate: The date the bounce took place
    - Domain: The domain of the subscriber	
    - IsUnique: Whether the event is unique or repeated
    - BounceCategoryID: The ID number for the bounce category	
    - BounceCategory: The category of the bounce	
    - BounceSubcategoryID: The ID number for the bounce subcategory	
    - BounceSubcategory: The subcategory of the bounce	
    - BounceTypeID: The ID number for the bounce type	
    - BounceType: The type of bounce that occurred	
    - SMTPBounceReason: The reason for the bounce relayed by the mail system	
    - SMTPMessage: The message regarding the bounce from the mail system	
    - SMTPCode: The error code for the bounce from the mail system	
    - TriggererSendDefinitionObjectID: The object ID for the triggered send definition	
    - TriggeredSendCustomerKey: The customer key for the triggered send

   LINKS: 
    - https://help.salesforce.com/s/articleView?id=sf.mc_as_data_view_subscribers.htm&type=5
    - https://mateuszdabrowski.pl/docs/config/sfmc-system-data-views/
*/

SELECT
    b.AccountID
    b.OYBAccountID
    b.JobID
    b.ListID
    b.BatchID
    b.SubscriberID
    b.SubscriberKey
    b.EventDate
    b.IsUnique
    b.Domain
    b.BounceCategoryID
    b.BounceCategory
    b.BounceSubcategoryID
    b.BounceSubcategory
    b.BounceTypeID
    b.BounceType
    b.SMTPBounceReason
    b.SMTPMessage
    b.SMTPCode
    b.TriggererSendDefinitionObjectID
    b.TriggeredSendCustomerKey
FROM [_Bounce] b

/*[BR] CONTAGEM DE BOUNCES POR CATEGORIA*/
/*[US] BOUNCE COUNT BY CATEGORY*/

SELECT
  SUM(CASE 
    WHEN BounceCategory = 'Hard Bounce' THEN 1
    ELSE 0
  END) AS [Hard Bounce],
  SUM(CASE 
    WHEN BounceCategory =  'Soft Bounce' THEN 1
    ELSE 0
  END) AS [Soft Bounce],
  SUM(CASE
    WHEN BounceCategory =  'Block Bounce' THEN 1
    ELSE 0
  END) AS [Block Bounce],
  SUM(CASE
    WHEN BounceCategory =  'Unknown Bounce' THEN 1
    ELSE 0
  END) AS Desconhecido
FROM
  ent.EUC_BR_Contact de
LEFT JOIN
  _Subscribers sub
  ON de.contactid = sub.SubscriberKey
LEFT JOIN
  _Sent s
  ON de.contactid = s.SubscriberKey
LEFT JOIN
  _Bounce b
  ON s.JobID = b.JobID
  AND s.ListID = b.ListID
  AND s.BatchID = b.BatchID
  AND s.SubscriberID = b.SubscriberID
WHERE
  CONVERT(VARCHAR(10), b.EventDate, 120) >= CONVERT(VARCHAR(10), GETDATE() - 1, 120)