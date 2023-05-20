/*
[BR]
   NOTA:
    - Armazena informações sobre seus envios de e-mail, ótimo para entender quem teve a chance de receber sua mensagem e qual comunicação não saiu do seu sistema.
   COLUNAS:
    - AccountID: Número de identificação da conta
    - OYBAccountID: Número de identificação para contas corporativas (MID)
    - JobID: Identificação para o envio do e-mail
    - ListID: Identificação da lista usada no envio
    - BatchID: Identificação do lote para lotes usados no envio
    - SubscriberID: Identificador exclusivo do seu assinante afetado pelo envio
    - SubscriberKey: Chave principal do seu assinante afetado pelo envio
    - EventDate: Data em que ocorreu o envio
    - Domain: Domínio do assinante
    - TriggererSendDefinitionObjectID: Identificador do objeto para a definição de envio acionado
    - TriggeredSendCustomerKey: A chave do cliente para o envio acionado

[US]  
   NOTE:
    - Stores information about your Email Sends. Great for understanding who had a chance to receive your message and whose communication did not leave your system.
   COLUMNS:
    - AccountID: Your account ID number	
    - OYBAccountID: The account ID number for any related On-Your-Behalf accounts. This field applies to enterprise accounts only. (MID)
    - JobID: The job ID number for the email send
    - ListID: The list ID number for the list used in the send
    - BatchID: The batch ID number for any batches used in the send	
    - SubscriberID: The subscriber ID for the affected subscriber. This number represents the unique ID for each subscriber record
    - SubscriberKey: The subscriber key for the affected subscriber
    - EventDate: The date the send took place
    - Domain: The domain of the subscriber	
    - TriggererSendDefinitionObjectID: The object ID for the triggered send definition
    - TriggeredSendCustomerKey: The customer key for the triggered send

    LINKS: 
    - https://help.salesforce.com/s/articleView?id=sf.mc_as_data_view_sent.htm&type=5
    - https://mateuszdabrowski.pl/docs/config/sfmc-system-data-views/  
*/

SELECT
    s.AccountID,
    s.OYBAccountID,
    s.JobID,
    s.ListID,
    s.BatchID,
    s.SubscriberID,
    s.SubscriberKey,
    s.EventDate,
    s.Domain,
    s.TriggererSendDefinitionObjectID,
    s.TriggeredSendCustomerKey
FROM [_Sent] s 