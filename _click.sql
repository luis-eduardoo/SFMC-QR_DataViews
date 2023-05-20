/*
[BR]
   NOTA:
    - Armazena informações sobre seus cliques de e-mail. Relatórios detalhados de cliques e lógica comportamental são possíveis.
   COLUNAS:
    - AccountID: Número de identificação da conta
    - OYBAccountID: Número de identificação para contas corporativas (MID)
    - JobID: Identificação para o envio do e-mail
    - ListID: Identificação da lista usada no envio
    - BatchID: Identificação do lote para lotes usados no envio
    - SubscriberID: Identificador exclusivo do seu assinante afetado pelo envio
    - SubscriberKey: Chave principal do seu assinante afetado pelo envio
    - EventDate: Data em que ocorreu o click
    - Domain: Domínio do assinante
    - URL: A URL do link clicado (AMPScript não são preenchidas. ex. www.example.com?%%attribute%%)
    - LinkName: Nome do link atribuído no envio de e-mail
    - LinkContent: O conteúdo do link atribuído no envio de e-mail. (AMPscript e variáveis são preenchidos nesta coluna. ex. como www.example.com?12345)
    - IsUnique: Se o evento é único ou repetido
    - TriggererSendDefinitionObjectID: Identificador do objeto para a definição de envio acionado
    - TriggeredSendCustomerKey: A chave do cliente para o envio acionado

[US]  
   NOTE:
    - Stores information about your Email Clicks. Detailed click reporting and behavioural logic are possible.
   COLUMNS:
    - AccountID: Your account ID number	
    - OYBAccountID: The account ID number for any related On-Your-Behalf accounts. This field applies to enterprise accounts only. (MID)
    - JobID: The job ID number for the email send
    - ListID: The list ID number for the list used in the send
    - BatchID: The batch ID number for any batches used in the send	
    - SubscriberID: The subscriber ID for the affected subscriber. This number represents the unique ID for each subscriber record
    - SubscriberKey: The subscriber key for the affected subscriber
    - EventDate: The date the click took place
    - Domain: The domain of the subscriber	
    - URL: The URL of the clicked link (AMPScript are not installed. ex. www.example.com?%%attribute%%)
    - LinkName: The link name assigned in the email send
    - LinkContent: The link content assigned in the email send. AMPscript and variables are populated in this column (ex. such as www.example.com?12345)
    - IsUnique: Whether the event is unique or repeated
    - TriggererSendDefinitionObjectID: The object ID for the triggered send definition
    - TriggeredSendCustomerKey: The customer key for the triggered send

   LINKS:
    - https://help.salesforce.com/s/articleView?id=sf.mc_as_data_view_click.htm&type=5 
    - https://mateuszdabrowski.pl/docs/config/sfmc-system-data-views/  
*/

SELECT
    c.AccountID,
    c.OYBAccountID,
    c.JobID,
    c.ListID,
    c.BatchID,
    c.SubscriberID,
    c.SubscriberKey,
    c.EventDate,
    c.Domain,
    c.URL,
    c.LinkName,
    c.LinkContent,
    c.IsUnique,
    c.TriggererSendDefinitionObjectID,
    c.TriggeredSendCustomerKey
FROM [_Click] c

/*[BR] USUÁRIOS QUE CLICARAM EM UM LINK ESPECÍFICO*/
/*[US] CLICKED ON A SPECIFIC LINK*/

SELECT
    c.AccountID,
    c.OYBAccountID,
    c.JobID,
    c.ListID,
    c.BatchID,
    c.SubscriberID,
    c.SubscriberKey,
    c.EventDate,
    c.Domain,
    c.URL,
    c.LinkName,
    c.LinkContent,
    c.IsUnique,
    c.TriggererSendDefinitionObjectID,
    c.TriggeredSendCustomerKey
FROM [_Click] c
from _Click as c
join _Subscribers as a on c.SubscriberID = a.SubscriberID
where c.URL = 'https://www.google.com/' --> link here