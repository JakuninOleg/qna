FactoryBot.define do
  sequence :body do |n|
    "#{n}-body"
  end

  factory :answer do
    body "Answer body"
  end

  factory :invalid_answer, class: "Answer" do
    body nil
  end
end
