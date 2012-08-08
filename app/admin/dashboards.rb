ActiveAdmin::Dashboards.build do

  section "Last update: " + (Status.last.present? ? Status.last.created_at.to_s : "never"), :priority => 0 do
    div do
      kpi_daily_volume_graph_period = params['kpi_daily_volume_graph_period'].present? ? params['kpi_daily_volume_graph_period'].to_i : 14

      #final render
      render "admin/dashboard/index", :handler => :haml, :locals => {
          :last_status => Status.last,
          :last_kpi => Kpi.last,
          :last_post => Post.last,
          :kpi_daily_volume_graph_period => kpi_daily_volume_graph_period,
          :kpi_daily_volume_graph => DashboardHelper.build_kpi_daily_volume_graph(kpi_daily_volume_graph_period),
          :post_sources_graph => DashboardHelper.build_post_sources_graph,
          :high_priority_posts => Post.all(:order => 'priority DESC', :limit => 10),
          :post_blog_sentiment_graph => DashboardHelper.build_post_blog_sentiment_graph
      }
    end
  end

end
