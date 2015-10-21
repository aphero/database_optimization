class ReportsController < ApplicationController
  helper_method :memory_in_mb

  def all_data
    @start_time = Time.now
    q = "#{params[:name]}"
    @sequences = []
    @genes = []
    @hits = []
    @assembly = Assembly.find_by_name(params[:name])

    # @assembly = Assembly.includes({hits: :match_gene_name}, {hits: :percent_similarity}, {hits: :match_gene_dna})

    @assembly.sequences.each do |s|
      @sequences << s
      s.genes.each do |g|
        @genes << g
        g.hits.each do |h|
          @hits << h
        end
      end
    end

    @hits.sort! {|a, b| b.percent_similarity <=> a.percent_similarity}

    @memory_used = memory_in_mb
  end

  private def memory_in_mb
    `ps -o rss -p #{$$}`.strip.split.last.to_i / 1024
  end
end
