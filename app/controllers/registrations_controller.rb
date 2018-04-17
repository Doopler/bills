class RegistrationsController < Devise::RegistrationsController
  prepend_before_action :check_captcha, only: [:create] # Change this to be any actions you want to protect.
  require 'net/http'


  def verify_google_recptcha(secret_key,response)
    status = `curl "https://www.google.com/recaptcha/api/siteverify?secret=#{secret_key}&response=#{response}"`
    logger.info "---------------status ==> #{status}"
    hash = JSON.parse(status)
    hash["success"] == true ? true : false
  end


  private
    def check_captcha
      secret = "6Lei1FMUAAAAANMBnFsAu2tyu0KLvuCqAOdhWSix"
      response = params['g-recaptcha-response']
      captcha_valid = verify_google_recptcha(secret,response)

      if captcha_valid
        self.resource = resource_class.new sign_up_params
        resource.validate # Look for any other validation errors besides Recaptcha
        set_minimum_password_length
        respond_with resource
      end
    end
end
