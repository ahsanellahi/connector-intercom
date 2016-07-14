class OauthController < ApplicationController

  def create_omniauth
    org_uid = params[:org_uid].present? ? params[:org_uid] : 'cld-9gjy'
    organization = Maestrano::Connector::Rails::Organization.find_by_uid_and_tenant(org_uid, current_user.tenant)

    if organization && is_admin?(current_user, organization)
      organization.update(
        oauth_name: request.env['omniauth.auth'][:provider],
        oauth_uid: request.env['omniauth.auth'][:uid],
        oauth_provider: request.env['omniauth.auth'][:provider],
        oauth_token: request.env['omniauth.auth'][:credentials][:token],
      )
    end

    redirect_to root_url
  end

  def destroy_omniauth
    organization = Maestrano::Connector::Rails::Organization.find_by_id(params[:organization_id])

    if organization && is_admin?(current_user, organization)
      organization.oauth_uid = nil
      organization.oauth_token = nil
      organization.refresh_token = nil
      organization.sync_enabled = false
      organization.save
    end

    redirect_to root_url
  end
end
