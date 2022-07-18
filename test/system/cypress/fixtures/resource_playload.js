import {Utilities} from "../support/utilities";

const resourceName = Utilities.getRandomString(8).toLocaleLowerCase();

export const resourceJson = {
  name: resourceName,
  abbreviation: resourceName,
  resourceOrganisation: "resource organisation",
  resourceProviders: [],
  webpage: "https://example.com",
  description: "description",
  tagline: "tagline",
  logo: "https://example.com",
  multimedia: [
    {
      "multimediaURL": "https://example.com",
      "multimediaName": "multimediaName"
    }
  ],
  useCases: [
    {
      "useCaseURL": "https://example.com",
      "useCaseName": "useCaseName"
    }
  ],
  scientificDomains: [
    {
      scientificDomain: "scientific_domain-humanities",
      scientificSubdomain: "scientific_subdomain-humanities-arts"
    }
  ],
  categories: [
    {
      category: "category-access_physical_and_eInfrastructures-compute",
      subcategory: "subcategory-access_physical_and_eInfrastructures-compute-orchestration"
    }
  ],
  targetUsers: [
    "target_user-businesses"
  ],
  accessTypes: [
    "access_type-mail_in"
  ],
  accessModes: [
    "access_mode-free"
  ],
  tags: [
    "tags"
  ],
  geographicalAvailabilities: [
    "AD"
  ],
  languageAvailabilities: [
    "ab"
  ],
  resourceGeographicLocations: [
    "AD"
  ],
  mainContact: {
    "firstName": "MC First Name",
    "lastName": "MC Last Name",
    "email": "test@mail.pl",
    "phone": "1234567890",
    "position": "Position",
    "organisation": "Organistation"
  },
  publicContacts: [
    {
      "firstName": "PC First Name",
      "lastName": "PC Last Name",
      "email": "test@mail.pl",
      "phone": "1234567890",
      "position": "Position",
      "organisation": "Organisation"
    }
  ],
  helpdeskEmail: "test@mail.pl",
  securityContactEmail: "test@mail.pl",
  trl: "trl-1",
  lifeCycleStatus: "life_cycle_status-production",
  certifications: [
    "Certifications"
  ],
  standards: [
    "Standards"
  ],
  openSourceTechnologies: [
    "OpenSourceTechnologies"
  ],
  version: "Verson Value",
  lastUpdate: "2020-01-01",
  changeLog: [
    "Changelog Value"
  ],
  requiredResources: [
    null
  ],
  relatedResources: [
    null
  ],
  relatedPlatforms: [
   "related_platform-egi"
  ],
  catalogueId: "eosc",
  fundingBody: [
    "funding_body-aka"
  ],
  fundingPrograms: [
    "funding_program-cf"
  ],
  grantProjectNames: [
    "Grant Project"
  ],
  helpdeskPage: "https://example.com",
  userManual: "https://example.com",
  termsOfUse: "https://example.com",
  privacyPolicy: "https://example.com",
  accessPolicy: "https://example.com",
  serviceLevel: "https://example.com",
  trainingInformation: "https://example.com",
  statusMonitoring: "https://example.com",
  maintenance: "https://example.com",
  orderType: "order_type-fully_open_access",
  order: "https://example.com",
  paymentModel: "https://example.com",
  pricing: "https://example.com"
}
