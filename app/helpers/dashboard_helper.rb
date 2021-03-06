module DashboardHelper
  class << self;

    def build_kpi_daily_volume_graph(period_in_days = 7)
      last_kpi = Kpi.last
      kpis = Kpi.all :conditions => "date BETWEEN (date '#{last_kpi.date}' - integer '#{period_in_days}') AND '#{last_kpi.date}'"

      categories = (last_kpi.date - period_in_days + 1).upto(last_kpi.date).collect{|day| day.to_s }
      series = categories.collect{|date|
        required_kpi = kpis.select{|kpi|
          kpi.date.to_s == date.to_s
        }
        required_kpi.empty? ? nil : required_kpi[0]
      }

      graph = Highcharts.new
      graph.chart({:renderTo => 'kpi_daily_volume_graph'})
      graph.title('')
      graph.xAxis([{:categories => categories}])
      graph.yAxis([{:title => '', :min => 0}])
      graph.legend({:layout => 'vertical', :align => 'right', :verticalAlign => 'top'})
      graph.series([
                       {:name => 'Petition signatures', :data => series.collect{|row| row.nil? ? 0 : row.petition_signatures}},
                       {:name => 'Petition recommendations', :data => series.collect{|row| row.nil? ? 0 : row.petition_recommendations}},
                       {:name => 'Tweets', :data => series.collect{|row| row.nil? ? 0 : row.tweets}},
                       {:name => 'Facebook discussions', :data => series.collect{|row| row.nil? ? 0 : row.facebook_discussions}},
                       {:name => 'Negative reviews on bhbhc facebook page', :data => series.collect{|row| row.nil? ? 0 : row.negative_reviews_on_bhbhc_fb}},
                       {:name => 'Negative reviews on barnabas health facebook page', :data => series.collect{|row| row.nil? ? 0 : row.negative_reviews_on_barnabas_health_fb}},
                       {:name => 'Email complaints', :data => series.collect{|row| row.nil? ? 0 : row.email_complaints}}
                   ])
      graph
    end

    def build_post_sources_graph
      posts = Post.all :select => "COUNT(*) AS count, media_provider",
                       :group => 'media_provider'

      series = posts.collect{|row| [row.media_provider.present? ? row.media_provider : "Other", row.count]}

      graph = Highcharts.new
      graph.chart({:renderTo => 'post_sources_graph'})
      graph.title('')
      graph.tooltip({
                        :formatter => "function(){return '<b>'+ this.point.name +'</b>: '+ this.percentage.toFixed(2) +' %' + ' (' + this.y + '/' + this.total + ')';}"
                    })
      graph.plotOptions({
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
      graph.series([
                       {:type => 'pie', :data => series}
                   ])
      graph
    end

    def build_post_blog_sentiment_graph
      posts = Post.all :select => "COUNT(*) AS count, blog_post_sentiment",
                       :conditions => "blog_post_sentiment != ''",
                       :group => 'blog_post_sentiment'

      series = posts.collect{|row| [row.blog_post_sentiment, row.count]}

      graph = Highcharts.new
      graph.chart({
                      :renderTo => 'post_blog_sentiment_graph',
                      :type => 'bar'
                  })
      graph.title('')
      graph.xAxis([{
                       :categories => [''],
                       :title => {
                           :text => nil
                       }
                   }])
      graph.yAxis([{
                       :min => 0,
                       :step => 1,
                       :title => {
                           :text => ''
                       },
                   }])
      graph.plotOptions({
                            :bar => {
                                :dataLabels => {
                                    :enabled => true
                                }
                            }
                        })
      graph.series(series.collect{|row| {:name => row[0], :data => [row[1]]}})
      graph
    end

  end

end
