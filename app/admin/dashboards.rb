ActiveAdmin::Dashboards.build do

  section "00001773 - LGBT Case Daily Volume", :priority => 1, :if => proc{ Kpi.last.present? }  do
    last_kpi = Kpi.last
    kpis = Kpi.all :conditions => "date BETWEEN (date '#{last_kpi.date}' - integer '7') AND '#{last_kpi.date}'",
                   :order => 'date DESC'

    categories = (last_kpi.date - 6).upto(last_kpi.date).collect{|day| day.to_s }
    series = categories.collect{|date|
      required_kpi = kpis.select{|kpi|
        kpi.date.to_s == date.to_s
      }
      required_kpi.empty? ? nil : required_kpi[0]
    }

    chart = Highcharts.new
    chart.chart({:renderTo => 'kpi_daily_volume_graph'})
    chart.title('')
    chart.xAxis([{:categories => categories}])
    chart.yAxis([{:title => '', :min => 0}])
    chart.legend({:layout => 'vertical', :align => 'right', :verticalAlign => 'top'})
    chart.series([
                   {:name => 'Petition signatures', :data => series.collect{|row| row.nil? ? 0 : row.petition_signatures}},
                   {:name => 'Petition recommendations', :data => series.collect{|row| row.nil? ? 0 : row.petition_recommendations}},
                   {:name => 'Tweets', :data => series.collect{|row| row.nil? ? 0 : row.tweets}},
                   {:name => 'Facebook discussions', :data => series.collect{|row| row.nil? ? 0 : row.facebook_discussions}},
                   {:name => 'Negative reviews on bhbhc facebook page', :data => series.collect{|row| row.nil? ? 0 : row.negative_reviews_on_bhbhc_fb}},
                   {:name => 'Negative reviews on barnabas health facebook page', :data => series.collect{|row| row.nil? ? 0 : row.negative_reviews_on_barnabas_health_fb}},
                   {:name => 'Email complaints', :data => series.collect{|row| row.nil? ? 0 : row.email_complaints}}
                 ])

    div do
      render :partial => "kpi_daily_volume", :locals => {:chart => chart}
    end
  end

  section "Posts per week", :priority => 2, :if => proc{ Post.last.present? } do
    posts = Post.all :select => "COUNT(*) AS count, date_trunc('week', MAX(publish_date))::date AS week_start",
                     :group => 'EXTRACT(WEEK FROM publish_date), EXTRACT(YEAR FROM publish_date)',
                     :order => 'week_start ASC'

    categories = posts.collect{|row| row.week_start.to_s}
    series = posts.collect{|row| row.count.to_i }

    chart = Highcharts.new
    chart.chart({:renderTo => 'posts_per_week_graph'})
    chart.title('')
    chart.xAxis([{:categories => categories}])
    chart.yAxis([{:title => 'Posts amount', :min => 0}])
    chart.series([
                     {:name => 'Posts amount', :yAxis => 0, :type => 'line', :data => series}
                 ])

    div do
      render :partial => "posts_per_week_graph", :locals => {:chart => chart}
    end
  end

  section "Post sources", :priority => 3, :if => proc{ Post.last.present? } do
    posts = Post.all :select => "COUNT(*) AS count, media_provider",
                     :group => 'media_provider'

    series = posts.collect{|row| [row.media_provider.present? ? row.media_provider : "Other", row.count]}

    chart = Highcharts.new
    chart.chart({:renderTo => 'post_sources_graph'})
    chart.title('')
    chart.tooltip({
                      :formatter => "function(){return '<b>'+ this.point.name +'</b>: '+ this.percentage.toFixed(2) +' %' + ' (' + this.y + '/' + this.total + ')';}"
                  })
    chart.plotOptions({
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
    chart.series([
                     {:type => 'pie', :data => series}
                 ])

    div do
      render :partial => "post_sources_graph", :locals => {:chart => chart}
    end
  end

  section "Post blog sentiments", :priority => 4, :if => proc{ Post.last.present? } do
    posts = Post.all :select => "COUNT(*) AS count, blog_post_sentiment",
                     :conditions => "blog_post_sentiment != ''",
                     :group => 'blog_post_sentiment'

    series = posts.collect{|row| [row.blog_post_sentiment, row.count]}

    chart = Highcharts.new
    chart.chart({
                    :renderTo => 'post_blog_sentiment_graph',
                    :type => 'bar'
                })
    chart.title('')
    chart.xAxis([{
                     :categories => [''],
                     :title => {
                         :text => nil
                     }
                 }])
    chart.yAxis([{
                     :min => 0,
                     :step => 1,
                     :title => {
                         :text => ''
                     },
                 }])
    chart.plotOptions({
                          :bar => {
                              :dataLabels => {
                                  :enabled => true
                              }
                          }
                      })
    chart.series(series.collect{|row| {:name => row[0], :data => [row[1]]}})

    div do
      render :partial => "post_blog_sentiment_graph", :locals => {:chart => chart}
    end
  end

  section "Last status", :priority => 100, :if => proc{ Status.last.present? } do
    last_status = Status.last
    div do
      b "Posted at #{last_status.created_at.to_s}: "
      span last_status.content
    end
  end

end
