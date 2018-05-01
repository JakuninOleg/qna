FactoryBot.define do
  factory :answer do
    body "Answer body"
  end

  factory :invalid_answer, class: "Answer" do
    body nil
  end
end
