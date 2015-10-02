class MainController < ApplicationController
  require 'open-uri'
  require 'pipeline'

  def index
    @pipeline_response = []
    JenkinsModules::Pipeline.all_names.split(' ').each do |pipeline|
      begin
        response = open(pipeline_url(pipeline)).read
        @json_response = JSON.parse(response)
        distinct_colors = @json_response["jobs"].map {|k| k["color"]}.uniq
        @pipeline_response << {"name" =>  pipeline, "url" => "/search?pipeline=#{pipeline}", "color" => current_status(distinct_colors) }
      rescue => ex
        Rails.logger.error "Pipeline: #{pipeline} " + ex.message
      end
    end
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
