require "spec_helper"
require "clipboard"

RSpec.describe "CLI", type: :aruba do
  context "with invalid options" do
    before do
      run "jwtgen --key my$ecretK3y --algorithm HS512 "\
          "--payload user_id=1123,email=INVALID,first_name=Jack,last_name=Hackett"
    end

    it "exits with status 1 and prints error message" do
      expect(last_command_started).to have_exit_status(1)
      expect(last_command_started).to have_output "** Error occurred: Email is invalid. Get help: jwtgen --help"
    end
  end

  context "with valid options" do
    before do
      run "jwtgen --key my$ecretK3y --algorithm HS512 "\
          "--payload user_id=1123,email=jack.hackett@example.com,first_name=Jack,last_name=Hackett"
    end

    it "generates JWT and copies it into clipboard" do
      expect(last_command_started).to be_successfully_executed
      expect(last_command_started).to have_output "The JWT has been copied to your clipboard!"
      decoded_payload = JWT.decode(Clipboard.paste, "my$ecretK3y", true, algorithm: "HS512").first
      expect(decoded_payload).to eq({
        "user_id"=>"1123",
        "email"=>"jack.hackett@example.com",
        "first_name"=>"Jack",
        "last_name"=>"Hackett"})
    end
  end
end
