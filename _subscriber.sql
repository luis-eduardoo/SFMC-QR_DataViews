/*
[BR]
   NOTA:
    - Armazena informações sobre suas aberturas de e-mail. Para quando você precisa saber quando alguém abriu seu e-mail.
   COLUNAS:
    - SubscriberKey: Chave principal do seu assinante (perfeito para identificar o usuário em exibições mais detalhadas)
    - SubscriberID: Identificador exclusivo do seu assinante (usado mais no back-end)
    - EmailAddress: Endereço de e-mail do assinante
    - Status: Status do assinante [ativo; retido; cancelou assinatura; rejeitado]
    - Domain: Domínio do assinante
    - DateUndeliverable: Data em que um e-mail não foi entregue para o assinante
    - DateJoined: Data que o assinante entrou em sua lista (Opt-In)
    - DateUnsubscribed: Data que o assinante cancelou a inscrição da sua lista (Opt-Out)
    - BounceCount: Numero total de "bounce" acumuladas pelo assinante
    - SubscriberType: Tipo do assinante [Exact Target; External System Unknown]
    - Locale: Código local do assinante (ex. pt-BR)


[US]  
   NOTE:
    - Stores information about your Email Opens. For when you need to know when someone opened your email.    
   COLUMNS:
    - SubscriberKey: Your subscriber's unique key (perfect for identifying the user in more detailed views)	
    - SubscriberID: Your subscriber's unique identifier (used more in the backend)
    - EmailAddress: The subscriber's email address	
    - Status: The status of the subscriber [active; held; unsubscribed; bounced]
    - Domain: The domain of the subscriber	
    - DateUndeliverable: The date an email for the subscriber was returned as undeliverable	
    - DateJoined: The date the subscriber joined your list	
    - DateUnsubscribed: The date the subscriber unsubscribed from your list	
    - BounceCount: The total number of bounces accrued by the subscriber	
    - SubscriberType: The subscriber type [Exact Target; External System Unknown]	
    - Locale: The locale code for the subscriber (ex. pt-BR)

   LINKS: 
    - https://help.salesforce.com/s/articleView?id=sf.mc_as_data_view_subscribers.htm&type=5
    - https://mateuszdabrowski.pl/docs/config/sfmc-system-data-views/
*/

SELECT
    s.SubscriberKey,
    s.SubscriberID,
    s.EmailAddress,
    s.Status,
    s.Domain,
    s.DateUndeliverable,
    s.DateJoined,
    s.DateUnsubscribed,
    s.BounceCount,
    s.SubscriberType,
    s.Locale
FROM 
    [_Subscribers] s


/*[BR] CONTAGEM DE DOMÍNIOS NA BU*/
/*[US] DOMAIN COUNT IN BU*/

SELECT
  s.Domain, -- [ex.gmail.com]
/*SUBSTRING(s.Domain, 0, CHARINDEX('.', s.Domain)) AS Domain,*/ -- [ex.gmail]
  COUNT(s.Domain) AS TOTAL
FROM 
    [_Subscribers] s
GROUP BY 
    s.Domain
ORDER BY 
    s.Domain DESC OFFSET 0 ROWS

/*[BR] CONTAGEM DE UNSUB DURANTE UM PERÍODO DE TEMPO*/
/*[US] UNSUB COUNT FOR A PERIOD OF TIME*/

SELECT
    s.SubscriberKey,
    s.SubscriberID,
    s.EmailAddress,
    s.Status,
    s.Domain,
    s.DateUndeliverable,
    s.DateJoined,
    s.DateUnsubscribed,
    s.BounceCount,
    s.SubscriberType,
    s.Locale
FROM 
    [_Subscribers] s
WHERE
    s.Status = 'Unsubscribed'
AND
    s.DateUnsubscribed >= getdate()-7 
/*[BR] Para filtrar por hora, usar "s.DateUnsubscribed > DATEADD(HH,-24, GETDATE())"*/
/*[US] To filter by hour, use "s.DateUnsubscribed > DATEADD(HH,-24, GETDATE())"*/

/*[BR] CONTAGEM DE ASSINANTES POR STATUS*/
/*[US] SUBSCRIBER COUNT BY STATUS*/

SELECT
  s.Status,
  COUNT(s.Status) AS TOTAL
FROM 
    [_Subscribers] s
GROUP BY 
    s.Status


/*[BR] VOLUMETRIA DE ENVIOS DE TODAS AS JORNADAS DA CONTA DURANTE UM PERÍODO*/
/*[US] SENDS ALL THE JOURNEYS IN THE ACCOUNT DURING A PERIOD*/

SELECT
    J.JourneyName,
    COUNT(*) AS VOLUME,
    CONVERT(CHAR(10),EventDate,120) AS DATA
FROM 
    _Journey J
INNER JOIN 
    _JourneyActivity A ON J.VersionID = A.VersionID
INNER JOIN 
    _Sent S ON A.JourneyActivityObjectID = S.TriggererSendDefinitionObjectID
WHERE 
    CONVERT(CHAR(10),EventDate,120) = CONVERT(CHAR(10),GETDATE(),120) 
GROUP BY 
    CONVERT(CHAR(10),EventDate,120),JourneyName


    