RSpec.describe "view help page" do
  before do
    visit help_path
  end

  it "displays help content" do
    expect(page).to have_content('How to use Cobra')
  end
end
