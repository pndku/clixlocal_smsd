ActiveAdmin::Dashboards.build do

  section "Last update: " + (Status.last.present? ? Status.last.created_at.to_s : "never"), :priority => 0 do
    div do
      #kpi_daily_volume_graph
      last_kpi = Kpi.last
      kpis = Kpi.all :conditions => "date BETWEEN (date '#{last_kpi.date}' - integer '7') AND '#{last_kpi.date}'"

      categories = (last_kpi.date - 6).upto(last_kpi.date).collect{|day| day.to_s }
      series = categories.collect{|date|
        required_kpi = kpis.select{|kpi|
          kpi.date.to_s == date.to_s
        }
        required_kpi.empty? ? nil : required_kpi[0]
      }

      kpi_daily_volume_graph = Highcharts.new
      kpi_daily_volume_graph.chart({:renderTo => 'kpi_daily_volume_graph'})
      kpi_daily_volume_graph.title('')
      kpi_daily_volume_graph.xAxis([{:categories => categories}])
      kpi_daily_volume_graph.yAxis([{:title => '', :min => 0}])
      kpi_daily_volume_graph.legend({:layout => 'vertical', :align => 'right', :verticalAlign => 'top'})
      kpi_daily_volume_graph.series([
                       {:name => 'Petition signatures', :data => series.collect{|row| row.nil? ? 0 : row.petition_signatures}},
                       {:name => 'Petition recommendations', :data => series.collect{|row| row.nil? ? 0 : row.petition_recommendations}},
                       {:name => 'Tweets', :data => series.collect{|row| row.nil? ? 0 : row.tweets}},
                       {:name => 'Facebook discussions', :data => series.collect{|row| row.nil? ? 0 : row.facebook_discussions}},
                       {:name => 'Negative reviews on bhbhc facebook page', :data => series.collect{|row| row.nil? ? 0 : row.negative_reviews_on_bhbhc_fb}},
                       {:name => 'Negative reviews on barnabas health facebook page', :data => series.collect{|row| row.nil? ? 0 : row.negative_reviews_on_barnabas_health_fb}},
                       {:name => 'Email complaints', :data => series.collect{|row| row.nil? ? 0 : row.email_complaints}}
                   ])

      #post_sources_graph
      posts = Post.all :select => "COUNT(*) AS count, media_provider",
                       :group => 'media_provider'

      series = posts.collect{|row| [row.media_provider.present? ? row.media_provider : "Other", row.count]}

      post_sources_graph = Highcharts.new
      post_sources_graph.chart({:renderTo => 'post_sources_graph'})
      post_sources_graph.title('')
      post_sources_graph.tooltip({
                        :formatter => "function(){return '<b>'+ this.point.name +'</b>: '+ this.percentage.toFixed(2) +' %' + ' (' + this.y + '/' + this.total + ')';}"
                    })
      post_sources_graph.plotOptions({
                            :pie => {
                                :allowPointSelect => true,
                                :cursor => 'pointer',
                                :dataLabels => {
                                    :enabled => true,
                                    :color => '#000000',
                                    :connectorColor => '#000000',
                                    :formatter => "function(){return '<b>'+ this.point.name +'</b>: '+ this.percentage.toFixed(2) +' %';}"
                                }
                            }
                        })
      post_sources_graph.series([
                       {:type => 'pie', :data => series}
                   ])

      #post_blog_sentiment_graph
      posts = Post.all :select => "COUNT(*) AS count, blog_post_sentiment",
                       :conditions => "blog_post_sentiment != ''",
                       :group => 'blog_post_sentiment'

      series = posts.collect{|row| [row.blog_post_sentiment, row.count]}

      post_blog_sentiment_graph = Highcharts.new
      post_blog_sentiment_graph.chart({
                      :renderTo => 'post_blog_sentiment_graph',
                      :type => 'bar'
                  })
      post_blog_sentiment_graph.title('')
      post_blog_sentiment_graph.xAxis([{
                       :categories => [''],
                       :title => {
                           :text => nil
                       }
                   }])
      post_blog_sentiment_graph.yAxis([{
                       :min => 0,
                       :step => 1,
                       :title => {
                           :text => ''
                       },
                   }])
      post_blog_sentiment_graph.plotOptions({
                            :bar => {
                                :dataLabels => {
                                    :enabled => true
                                }
                            }
                        })
      post_blog_sentiment_graph.series(series.collect{|row| {:name => row[0], :data => [row[1]]}})

      #final render
      render "admin/dashboard/index", :handler => :haml, :locals => {
          :last_status => Status.last,
          :last_kpi => Kpi.last,
          :last_post => Post.last,
          :kpi_daily_volume_graph => kpi_daily_volume_graph,
          :post_sources_graph => post_sources_graph,
          :post_blog_sentiment_graph => post_blog_sentiment_graph,
      }
    end
  end

end
