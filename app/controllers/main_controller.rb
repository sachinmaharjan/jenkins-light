class MainController < ApplicationController
  require 'open-uri'
  require 'pipeline'
  WALL_PIPELINES = %w(Blurby-Master-PL Blurby-Production-PL Drupal-Master-PL)

  def index
    @pipeline_response = []
    @wall_pipelines = []
    JenkinsModules::Pipeline.all_names.split(' ').each do |pipeline|
      begin
        response = open(pipeline_url(pipeline)).read
        @json_response = JSON.parse(response)
        distinct_colors = @json_response["jobs"].map {|k| k["color"]}.uniq
        json_pipeline = {"name" =>  pipeline, "url" => "/search?pipeline=#{pipeline}", "color" => current_status(distinct_colors) }
        @pipeline_response << json_pipeline
        @wall_pipelines << json_pipeline if WALL_PIPELINES.include? json_pipeline["name"]
      rescue => ex
        Rails.logger.error "Pipeline: #{pipeline} " + ex.message
      end
    end
    @pipeline_response = @pipeline_response.sort_by {|h| h["color"]}.reverse
  end

  def search
    begin
      redirect_to index if params[:pipeline].blank?
      response = open(pipeline_url(params[:pipeline])).read
      @json_response = JSON.parse(response)
    rescue => ex
      Rails.logger.error "Pipeline: #{params[:pipeline]} " + ex.message
    end
  end

  private
  def pipeline_url(pipeline)
    "http://jenkins.blurb.com/view/Pipelines/view/#{pipeline}/api/json"
  end

  def current_status(colors)
    if colors.include? 'red'
      return 'red'
    elsif colors.include? 'red_anime'
      return 'red_anime'
    elsif colors.include? 'yellow'
      return 'yellow'
    elsif colors.include? 'yellow_anime'
      return 'yellow_anime'
    elsif colors.include? 'blue'
      return 'blue'
    elsif colors.include? 'blue_anime'
      return 'blue_anime'
    else
      return 'aborted'
    end
  end
end
