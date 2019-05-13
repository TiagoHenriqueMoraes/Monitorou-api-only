module Api::V1
  class QuestionnairesController < ApiController
    before_action :set_questionnaire, only: %i[update destroy show]
    # before_action :authorize_user, only: %i[create update destroy]

    def index
      @questionnaires = Questionnaire.all
      render json: @questionnaires, except: [:created_at, :updated_at], 
                                    include: {questionnaire_options: {only: %i[id description correct],
                                                                      includes: {subject: {only: %i[id name]}},
                                                                      includes: {institution: {only: %i[id name]}}}}
    end

    def create
      @questionnaire = Questionnaire.new(questionnaire_params)
      if @questionnaire.save
        render_questionnaire
      else
        render json: @questionnaire.errors, status: :unprocessable_entity
      end
    end

    def update
      if @questionnaire.update(questionnaire_params)
        render_questionnaire  
      else
        render json: @questionnaire.errors, status: :unprocessable_entity
      end
    end

    def destroy
      @questionnaire.destroy
    end

    def show
      render_questionnaire
    end

    private
  
    # def authorize_user
    #   authorize Questionnaire
    # end

    def render_questionnaire
      render json: @questionnaire, include: {questionnaire_options: {only: %i[id description correct],
                                             includes: {subject: {only: %i[id name]}},
                                             includes: {institution: {only: %i[id name]}}}}
    end

    def set_questionnaire
      @questionnaire = Questionnaire.find(params[:id])
    end

    def questionnaire_params
      params.require(:questionnaire).permit(:subject_id, :description, :institution_id,
                                            questionnaire_options_attributes: %i[id questionnaire_id correct description])
    end
  end
end
