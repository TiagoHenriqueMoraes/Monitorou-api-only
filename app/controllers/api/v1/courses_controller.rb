module Api::V1  
  class CoursesController < ApiController
    before_action :set_course, only: [:update, :destroy]

    def index
      @courses = Course.all
      render json: @courses, only: [:name], :include => {:institution => {:only => :name}}
    end

    def create
      @course = Course.new(course_params)
      if @course.save
        render json: @course
      else
        render json: @course.errors, status: :unprocessable_entity
      end
    end

    def update
      if @course.update(course_params)
        render json: @course
      else
        render json: @course.errors, status: :unprocessable_entity
      end
    end

    def destroy
      @course.destroy
    end

    private

    def set_course
      @course = Course.find(params[:id])
    end

    def course_params
      params.require(:course).permit(:name, :institution_id)
    end

  end
end