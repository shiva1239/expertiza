require 'rails_helper'

RSpec.describe SampleReviewsController, type: :controller do
  let(:team) { build(:assignment_team, id: 1, name: 'team no name', assignment: assignment, users: [student], parent_id: 1) }
  let(:team1) { build(:assignment_team, id: 2, name: 'team has name', assignment: assignment, users: [student]) }
  let(:review_response_map) { build(:review_response_map, id: 1, assignment: assignment, reviewer: participant, reviewee: team) }
  let(:review_response_map1) do
    build :review_response_map,
          id: 2,
          assignment: assignment,
          reviewer: participant1,
          reviewee: team1,
          reviewed_object_id: 1,
          response: [response],
          calibrate_to: 0
  end
  let(:feedback) { FeedbackResponseMap.new(id: 1, reviewed_object_id: 1, reviewer_id: 1, reviewee_id: 1) }
  let(:participant) { build(:participant, id: 1, parent_id: 1, user: student) }
  let(:participant1) { build(:participant, id: 2, parent_id: 2, user: student1) }
  let(:assignment) { build(:assignment, id: 1, name: 'Test Assgt', rounds_of_reviews: 2) }
  let(:assignment1) { build(:assignment, id: 2, name: 'Test Assgt', rounds_of_reviews: 1) }
  let(:responsex) { build(:response, id: 1, map_id: 1, round: 1, response_map: review_response_map,  is_submitted: true) }
  let(:response1) { build(:response, id: 2, map_id: 1, round: 2, response_map: review_response_map) }
  let(:response2) { build(:response, id: 3, map_id: 1, round: nil, response_map: review_response_map, is_submitted: true) }
  let(:metareview_response_map) { build(:meta_review_response_map, reviewed_object_id: 1) }
  let(:student) { build(:student, id: 1, name: 'name', fullname: 'no one', email: 'expertiza@mailinator.com') }
  let(:student1) { build(:student, id: 2, name: "name1", fullname: 'no one', email: 'expertiza@mailinator.com') }
  let(:questionnaire) { Questionnaire.new(id: 1, type: 'ReviewQuestionnaire') }
  before(:each) do
    allow(Assignment).to receive(:find).with('1').and_return(assignment)
    allow(Response).to receive(:find).with('1').and_return(responsex)
    instructor = build(:instructor)
    stub_current_user(instructor, instructor.role.name, instructor.role)
  end

  describe '#map_to_assignment' do
    context 'when Instructor selects assignments for sample reviews to be published to' do
      it 'add entry in sampleReviews and marks response visibility to published' do
        params = {id: 1, assignments: [1,2],format: :json}
        session = {user: build(:instructor, id: 1)}
        post :map_to_assignment, params, session
        expect(responsex).to have_attributes(visibility: 'published')
        expect(response).to have_http_status(201)
      end
    end
  end
  describe '#unmap_from_assignment' do
    context 'when Instructor selects to umark sample review from all assignments' do
      it 'deletes mapping and marks response visibility to public' do
        params = {id: 1,format: :json}
        session = {user: build(:instructor, id: 1)}
        post :unmap_from_assignment, params, session
        expect(responsex).to have_attributes(visibility: 'public')
        expect(response).to have_http_status(204)
      end
    end
  end
  end
