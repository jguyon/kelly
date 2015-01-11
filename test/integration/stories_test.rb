require 'test_helper'

class StoriesTest < ActionDispatch::IntegrationTest
  setup do
    Capybara.current_driver = Capybara.javascript_driver
  end

  test "creates and publish a new questionnaire" do
    visit root_path

    fill_in t('helpers.label.questionnaire.name'), with: 'Chemistry'
    click_on t('helpers.submit.questionnaire.create')
    assert_text 'Chemistry'

    click_on t('questions.new_link.text')
    fill_in Question.human_attribute_name(:title), with: 'C = ?'
    click_on t('helpers.submit.question.create')
    assert_text 'C = ?'
    question_one = find("#question_#{Question.last.id}")
    question_one_answer_one = question_one_answer_two = nil

    within question_one do
      click_on t('answers.new_link.text')
      fill_in Answer.human_attribute_name(:title), with: 'Carbon'
      click_on t('helpers.submit.answer.create')
      assert_text 'Carbon'
      question_one_answer_one = find("#answer_#{Answer.last.id}")

      click_on t('answers.new_link.text')
      fill_in Answer.human_attribute_name(:title), with: 'Clcm'
      click_on t('helpers.submit.answer.create')
      assert_text 'Clcm'
      question_one_answer_two = find("#answer_#{Answer.last.id}")

      within question_one_answer_two do
        find('.mdi-content-create').click
      end
      fill_in Answer.human_attribute_name(:title), with: 'Calcium'
      click_on t('helpers.submit.answer.update')
      assert_text 'Calcium'

      within question_one_answer_one do
        find('.mdi-toggle-check-box-outline-blank').click
        assert_selector '.mdi-toggle-check-box'
      end

      within question_one_answer_two do
        find('.mdi-action-open-with').drag_to question_one_answer_one
      end
      assert page.body.index('Calcium') < page.body.index('Carbon')
    end

    click_on t('questions.new_link.text')
    fill_in Question.human_attribute_name(:title), with: 'x = ?'
    click_on t('helpers.submit.question.create')
    assert_text 'x = ?'
    question_two = find("#question_#{Question.last.id}")

    within question_two do
      find('.mdi-content-create').click
    end
    fill_in Question.human_attribute_name(:title), with: 'H = ?'
    click_on t('helpers.submit.question.update')
    assert_text 'H = ?'

    question_two_answer_one = question_two_answer_two = nil
    within question_two do
      click_on t('answers.new_link.text')
      fill_in Answer.human_attribute_name(:title), with: 'Helium'
      click_on t('helpers.submit.answer.create')
      assert_text 'Helium'
      question_two_answer_one = find("#answer_#{Answer.last.id}")

      click_on t('answers.new_link.text')
      fill_in Answer.human_attribute_name(:title), with: 'Hydrogen'
      click_on t('helpers.submit.answer.create')
      assert_text 'Hydrogen'
      question_two_answer_two = find("#answer_#{Answer.last.id}")

      within question_two_answer_two do
        find('.mdi-toggle-check-box-outline-blank').click
        assert_selector '.mdi-toggle-check-box'
      end
    end

    within question_one do
      first('.mdi-action-open-with').drag_to question_two
    end
    assert page.body.index('H = ?') < page.body.index('C = ?')

    within question_two_answer_one do
      find('.mdi-content-clear').click
    end
    assert_no_text 'Helium'

    within question_two do
      first('.mdi-content-clear').click
    end
    assert_no_text 'H = ?'

    click_link t('questions.index.settings')
    fill_in Questionnaire.human_attribute_name(:points_for_correct_answer),
      with: 3
    fill_in Questionnaire.human_attribute_name(:points_for_incorrect_answer),
      with: -1
    click_on t('questionnaires.edit.publish')
    assert_text new_questionnaire_take_path(Questionnaire.last.token)
  end

  test "takes a questionnaire" do
    visit new_questionnaire_take_path(questionnaires(:physics).token)

    fill_in t('helpers.label.take.name'), with: 'Trent'
    click_on t('helpers.submit.take.create')
    question_one = questions(:physics_one)
    assert_text question_one.title
    question_one.answers.each { |answer| assert_text answer.title }

    question_one.answers.each do |answer|
      within "#answer_#{answer.id}" do
        find('.mdi-toggle-check-box-outline-blank').click
        assert_selector '.mdi-toggle-check-box'
      end
    end
    within "#answer_#{answers(:physics_one_incorrect).id}" do
      find('.mdi-toggle-check-box').click
      assert_selector '.mdi-toggle-check-box-outline-blank'
    end

    click_on t('entries.show.next_question')
    question_two = questions(:physics_two)
    assert_text question_two.title
    question_two.answers.each { |answer| assert_text answer.title }

    question_two.answers.each do |answer|
      within "#answer_#{answer.id}" do
        find('.mdi-toggle-check-box-outline-blank').click
        assert_selector '.mdi-toggle-check-box'
      end
    end

    click_on t('entries.show.next_question')
    question_three = questions(:physics_three)
    assert_text question_three.title
    question_three.answers.each { |answer| assert_text answer.title }

    click_on t('entries.show.next_question')
    assert_text t('takes.show.score', score: 1, max: 6)
  end
end
