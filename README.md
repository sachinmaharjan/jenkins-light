# jenkins-light

Clone the repo and cd into the directory and run the following commands: 
```
> bundle install

> rails server

```

### Change your Jenkins API url in main_controller.rb
```
def pipeline_url(pipeline)
  "http://jenkins.blurb.com/view/Pipelines/view/#{pipeline}/api/json"
end
```

### Add or remove pipeline names in pipeline.yml 

