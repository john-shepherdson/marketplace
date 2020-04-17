# frozen_string_literal: true


FactoryBot.define do
  factory :jms_response, class: String do
    skip_create
    { "resourceId": "13b90013-2e17-4ad9-a260-3b59a598f189",
      "resourceType": "infra_service",
      "resource":
      "<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\"?>
        <tns:infraService xmlns:tns=\"http://einfracentral.eu\">
          <tns:active>true</tns:active>
            <tns:metadata>
              <tns:modifiedAt>1582551172233</tns:modifiedAt>
              <tns:modifiedBy>Κωνσταντίνος Σπύρου</tns:modifiedBy>
              <tns:registeredAt>1581599073319</tns:registeredAt>
              <tns:registeredBy>mike mike</tns:registeredBy>
            </tns:metadata>
            <tns:latest>true</tns:latest>
            <tns:service><tns:accessModes>
    <tns:accessMode>access_mode-peer_reviewed
    </tns:accessMode>
    </tns:accessModes>
    <tns:accessPolicy>http://service-name.service-provider.eu/AccessPolicies
    </tns:accessPolicy>
    <tns:accessTypes>
    <tns:accessType>access_type-virtual</tns:accessType>
    </tns:accessTypes>
    <tns:aggregatedServices>5</tns:aggregatedServices>
    <tns:applications>200000</tns:applications>
    <tns:certifications/>
    <tns:changeLog>Upgrade of user interface. Correction of minor bugs.</tns:changelog>
    <tns:contacts>
    <tns:contact>
    <tns:email>spyroukon@gmail.com</tns:email>
    <tns:firstName>Konstantinos</tns:firstName>
    <tns:lastName>Spyrou</tns:lastName>
    <tns:position>The Boss</tns:position>
    <tns:tel>0000000000</tns:tel>
    </tns:contact>
    </tns:contacts>
    <tns:datasets>16</tns:datasets>
    <tns:description>&lt;p&gt;Pika Pi pi&lt;/p&gt;</tns:description>
    <tns:funders>
    <tns:funder>mse</tns:funder>
    <tns:funder>ancs</tns:funder>
    </tns:funders>
    <tns:helpdesk>http://service-name.service-provider.eu/Helpdesk</tns:helpdesk>
    <tns:id>DEV.kittens</tns:id>
    <tns:languages>
    <tns:language>english</tns:language>
    </tns:languages>
    <tns:lastUpdate>2018-02-02T00:00:00.000Z</tns:lastUpdate>
    <tns:logo>https://icons-for-free.com/iconfiles/png/512/go+pikachu+play+pokemon+icon-1320186973527720987.png</tns:logo>
    <tns:maintenance>http://service-name.service-provider.eu/Maintenance</tns:maintenance>
    <tns:monitoring>http://service-name.service-provider.eu/Monitoring</tns:monitoring>
    <tns:multimediaUrls>
    <tns:multimediaUrl>http://service-name.service-provider.eu/Multimedia</tns:multimediaUrl>
    </tns:multimediaUrls>
    <tns:name>Ki TT ens</tns:name>
    <tns:options>
    <tns:option>
    <tns:attributes>
    <tns:attribute>attribute1</tns:attribute>
    <tns:attribute>attribute2</tns:attribute>
    </tns:attributes>
    <tns:contacts>
    <tns:contact>
    <tns:email>mike@gmail.com</tns:email>
    <tns:firstName>Mike</tns:firstName>
    <tns:lastName>Z</tns:lastName>
    <tns:position>test</tns:position>
    <tns:tel>0123456789</tns:tel>
    </tns:contact>
    </tns:contacts>
    <tns:description>Standard Option</tns:description>
    <tns:name>Standard</tns:name>
    <tns:url>https://standard.com</tns:url>
    </tns:option>
    </tns:options>
    <tns:order>http://service-name.service-provider.eu/Order</tns:order>
    <tns:orderType>order_type-fully_open_access</tns:orderType>
    <tns:otherProducts>0</tns:otherProducts>
    <tns:phase>phase-production</tns:phase>
    <tns:places>
    <tns:place>WW</tns:place>
    </tns:places>
    <tns:pricing>http://service-name.service-provider.eu/Price</tns:pricing>
    <tns:providers>
    <tns:provider>DEV</tns:provider>
    </tns:providers>
    <tns:publications>10000</tns:publications>
    <tns:relatedPlatforms>
    <tns:relatedPlatform>WeNMR Suite</tns:relatedPlatform>
    </tns:relatedPlatforms>
    <tns:relatedServices/>
    <tns:requiredServices/>
    <tns:scientificSubdomains>
    <tns:scientificSubdomain>scientific_subdomain-interdisciplinary-interdisciplinary</tns:scientificSubdomain>
    </tns:scientificSubdomains>
    <tns:sla>http://service-name.service-provider.eu/SLA</tns:sla>
    <tns:software>14</tns:software>
    <tns:standards>
    <tns:standard>ISO 15430</tns:standard>
    <tns:standard>ISO 27000</tns:standard>
    </tns:standards><tns:subcategories>
    <tns:subcategory>subcategory-aggregators_and_integrators-aggregators_and_integrators-software</tns:subcategory>
    </tns:subcategories>
    <tns:tagline>Gotta Catch Em All!</tns:tagline>
    <tns:tags>
    <tns:tag>open science</tns:tag>
    <tns:tag>data</tns:tag>
    <tns:tag>dataset</tns:tag>
    <tns:tag>data archive</tns:tag>
    <tns:tag>library</tns:tag>
    <tns:tag>repository</tns:tag>
    </tns:tags>
    <tns:targetUsers>
    <tns:targetUser>target_users-researchers</tns:targetUser>
    </tns:targetUsers>
    <tns:termsOfUse>http://service-name.service-provid-er.eu/TermsOfUse</tns:termsOfUse>
    <tns:training>http://service-name.service-provider.eu/Training</tns:training>
    <tns:trl>trl-8</tns:trl>
    <tns:url>http://www.developers.pokemonmasters.com</tns:url>
    <tns:useCases/>
    <tns:userBaseList>
    <tns:userBase>900+ pokemons</tns:userBase>
    </tns:userBaseList>
    <tns:userManual>http://service-name.service-provid-er.eu/UserManual</tns:userManual>
    <tns:userValue>Mew.</tns:userValue>
    <tns:version>3.1</tns:version>
    </tns:service>
    </tns:infraService>",
    "payloadFormat": "xml",
    "previous": "<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\"?>
    <tns:infraService xmlns:tns=\"http://einfracentral.eu\"><tns:active>true</tns:active><tns:metadata><tns:modifiedAt>1582550875231</tns:modifiedAt><tns:modifiedBy>Κωνσταντίνος Σπύρου</tns:modifiedBy><tns:registeredAt>1581599073319</tns:registeredAt><tns:registeredBy>mike mike</tns:registeredBy></tns:metadata><tns:latest>true</tns:latest><tns:service><tns:accessModes><tns:accessMode>access_mode-peer_reviewed</tns:accessMode></tns:accessModes><tns:accessPolicy>http://service-name.service-provider.eu/AccessPolicies</tns:accessPolicy><tns:accessTypes><tns:accessType>access_type-virtual</tns:accessType></tns:accessTypes><tns:aggregatedServices>5</tns:aggregatedServices><tns:applications>200000</tns:applications><tns:certifications/><tns:changeLog>Upgrade of user interface. Correction of minor bugs.</tns:changelog><tns:contacts><tns:contact><tns:email>spyroukon@gmail.com</tns:email><tns:firstName>Konstantinos</tns:firstName><tns:lastName>Spyrou</tns:lastName><tns:position>The Boss</tns:position><tns:tel>0000000000</tns:tel></tns:contact></tns:contacts><tns:datasets>16</tns:datasets><tns:description>&lt;p&gt;Pika Pi&lt;/p&gt;</tns:description><tns:funders><tns:funder>mse</tns:funder><tns:funder>ancs</tns:funder></tns:funders><tns:helpdesk>http://service-name.service-provider.eu/Helpdesk</tns:helpdesk><tns:id>DEV.kittens</tns:id><tns:languages><tns:language>english</tns:language></tns:languages><tns:lastUpdate>2018-02-02T00:00:00.000Z</tns:lastUpdate><tns:logo>https://icons-for-free.com/iconfiles/png/512/go+pikachu+play+pokemon+icon-1320186973527720987.png</tns:logo><tns:maintenance>http://service-name.service-provider.eu/Maintenance</tns:maintenance><tns:monitoring>http://service-name.service-provider.eu/Monitoring</tns:monitoring><tns:multimediaUrls><tns:multimediaUrl>http://service-name.service-provider.eu/Multimedia</tns:multimediaUrl></tns:multimediaUrls><tns:name>Ki TT ens</tns:name><tns:options><tns:option><tns:attributes><tns:attribute>attribute1</tns:attribute><tns:attribute>attribute2</tns:attribute></tns:attributes><tns:contacts><tns:contact><tns:email>mike@gmail.com</tns:email><tns:firstName>Mike</tns:firstName><tns:lastName>Z</tns:lastName><tns:position>test</tns:position><tns:tel>0123456789</tns:tel></tns:contact></tns:contacts><tns:description>Standard Option</tns:description><tns:name>Standard</tns:name><tns:url>https://standard.com</tns:url></tns:option></tns:options><tns:order>http://service-name.service-provider.eu/Order</tns:order><tns:orderType>order_type-fully_open_access</tns:orderType><tns:otherProducts>0</tns:otherProducts><tns:phase>phase-production</tns:phase><tns:places><tns:place>WW</tns:place></tns:places><tns:pricing>http://service-name.service-provider.eu/Price</tns:pricing><tns:providers><tns:provider>DEV</tns:provider></tns:providers><tns:publications>10000</tns:publications><tns:relatedPlatforms><tns:relatedPlatform>WeNMR Suite</tns:relatedPlatform></tns:relatedPlatforms><tns:relatedServices/><tns:requiredServices/><tns:scientificSubdomains><tns:scientificSubdomain>scientific_subdomain-interdisciplinary-interdisciplinary</tns:scientificSubdomain></tns:scientificSubdomains><tns:sla>http://service-name.service-provider.eu/SLA</tns:sla><tns:software>14</tns:software><tns:standards><tns:standard>ISO 15430</tns:standard><tns:standard>ISO 27000</tns:standard></tns:standards><tns:subcategories><tns:subcategory>subcategory-aggregators_and_integrators-aggregators_and_integrators-software</tns:subcategory></tns:subcategories><tns:tagline>Gotta Catch Em All!</tns:tagline><tns:tags><tns:tag>open science</tns:tag><tns:tag>data</tns:tag><tns:tag>dataset</tns:tag><tns:tag>data archive</tns:tag><tns:tag>library</tns:tag><tns:tag>repository</tns:tag></tns:tags><tns:targetUsers><tns:targetUser>target_users-researchers</tns:targetUser></tns:targetUsers><tns:termsOfUse>http://service-name.service-provid-er.eu/TermsOfUse</tns:termsOfUse><tns:training>http://service-name.service-provider.eu/Training</tns:training><tns:trl>trl-8</tns:trl><tns:url>http://www.developers.pokemonmasters.com</tns:url><tns:useCases/><tns:userBaseList><tns:userBase>900+ pokemons</tns:userBase></tns:userBaseList><tns:userManual>http://service-name.service-provid-er.eu/UserManual</tns:userManual><tns:userValue>Mew.</tns:userValue><tns:version>3.1</tns:version></tns:service></tns:infraService>"}
  end
end
