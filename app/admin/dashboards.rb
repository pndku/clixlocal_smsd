ActiveAdmin::Dashboards.build do

  section "Posts per week", :priority => 1, :if => Post.last.present? do
    posts = Post.all :select => "COUNT(*) AS count, date_trunc('week', MAX(publish_date))::date AS week_start",
                     :group => 'EXTRACT(WEEK FROM publish_date), EXTRACT(YEAR FROM publish_date)',
                     :order => 'week_start ASC'

    x_labels = posts.collect{|row| row.week_start.to_s}
    y_posts = posts.collect{|row| row.count.to_i }

    chart = Highcharts.new
    chart.chart({:renderTo => 'posts_per_week_graph'})
    chart.title('')
    chart.xAxis([{:categories => x_labels}])
    chart.yAxis([{:title => 'Posts amount', :min => 0}])
    chart.series([
                     {:name => 'Posts amount', :yAxis => 0, :type => 'line', :data => y_posts}
                 ])

    div do
      render :partial => "posts_per_week_graph", :locals => {:chart => chart}
    end
  end

  section "Post sources", :priority => 2, :if => Post.last.present? do
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

  section "Post blog sentiments", :priority => 3, :if => Post.last.present? do
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

  section "Last status", :priority => 100, :if => Status.last.present? do
    last_status = Status.last
    div do
      b "Posted at #{last_status.created_at}: "
      span last_status.content
    end
  end

  # Define your dashboard sections here. Each block will be
  # rendered on the dashboard in the context of the view. So just
  # return the content which you would like to display.

  # == Simple Dashboard Section
  # Here is an example of a simple dashboard section
  #
  #   section "Recent Posts" do
  #     ul do
  #       Post.recent(5).collect do |post|
  #         li link_to(post.title, admin_post_path(post))
  #       end
  #     end
  #   end

  # == Render Partial Section
  # The block is rendered within the context of the view, so you can
  # easily render a partial rather than build content in ruby.
  #
  #   section "Recent Posts" do
  #     div do
  #       render 'recent_posts' # => this will render /app/views/admin/dashboard/_recent_posts.html.erb
  #     end
  #   end

  # == Section Ordering
  # The dashboard sections are ordered by a given priority from top left to
  # bottom right. The default priority is 10. By giving a section numerically lower
  # priority it will be sorted higher. For example:
  #
  #   section "Recent Posts", :priority => 10
  #   section "Recent User", :priority => 1
  #
  # Will render the "Recent Users" then the "Recent Posts" sections on the dashboard.

  # == Conditionally Display
  # Provide a method name or Proc object to conditionally render a section at run time.
  #
  # section "Membership Summary", :if => :memberships_enabled?
  # section "Membership Summary", :if => Proc.new { current_admin_user.account.memberships.any? }

end
