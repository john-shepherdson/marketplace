import { confEnv } from "../../support/provider_portal_env"
import { providerJson } from "../../fixtures/provider_playload"

before(() => {
  cy.getAccessToken()
})

describe("Provider Portal - approve provider", () => {

  it("create provider, approve, deactive, active and delete it", { tags: '@integration-PC-tests' }, () => {

    const token = confEnv.PROVIDER_PORTAL_ACCESS_TOKEN();
    const providerPortalURL = confEnv.PROVIDER_PORTAL_URL()
    const marketplaceURL = confEnv.MARKETPLACE_URL()
    const authorization = `Bearer ${token}`;
    const provider = providerJson

    cy.request({
      method: 'POST',
      url: `${providerPortalURL}/api/provider/`,
      form: false,

      headers: {
        Authorization: authorization,
        "Content-Type": "application/json"
      },
      body: (JSON.stringify(provider))
    });

    cy.visit(`${marketplaceURL}`);
    cy.checkInvisibilityOfProviderInMarketplace(provider.name)

    cy.request({
      method: 'PATCH',
      url: `${providerPortalURL}/api/provider/verifyProvider/${provider.name}?active=true&status=approved provider`,
      form: false,

      headers: {
        Authorization: authorization,
        "Content-Type": "application/json"
      }
    });

    cy.visit(`${marketplaceURL}`);
    cy.checkVisibilityOfProviderInMarketplace(provider.name)
    cy.get("[data-e2e='provider-details-btn']")
      .click();
    cy.checkVisibilityOfProviderDetails();
    cy.get("[data-e2e='provider-about-btn']")
      .click();
    cy.checkVisibilityOfProviderAbout();

    cy.request({
      method: 'PATCH',
      url: `${providerPortalURL}/api/provider/verifyProvider/${provider.name}?active=false&status=approved provider`,
      form: false,

      headers: {
        Authorization: authorization,
        "Content-Type": "application/json"
      }
    });

    cy.visit(`${marketplaceURL}`);
    cy.checkInvisibilityOfProviderInMarketplace(provider.name)


    cy.request({
      method: 'PATCH',
      url: `${providerPortalURL}/api/provider/verifyProvider/${provider.name}?active=true&status=approved provider`,
      form: false,

      headers: {
        Authorization: authorization,
        "Content-Type": "application/json"
      }
    });

    cy.visit(`${marketplaceURL}`);
    cy.checkVisibilityOfProviderInMarketplace(provider.name)


    cy.request({
      method: 'DELETE',
      url: `${providerPortalURL}/api/provider/${provider.name}`,
      form: false,

      headers: {
        Authorization: authorization,
        "Content-Type": "application/json"
      }
    });

    cy.visit(`${marketplaceURL}`);
    cy.checkInvisibilityOfProviderInMarketplace(provider.name)
  });
});

